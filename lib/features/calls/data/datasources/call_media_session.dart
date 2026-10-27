import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:metered_realtime/metered_realtime.dart';
import 'package:yeetfit/core/services/call_native_service.dart';
import 'call_exception.dart';

/// WebRTC media for one call: captures the local microphone (and camera),
/// publishes it on a Metered realtime channel and surfaces the other party's
/// stream. Single use — [close] is terminal.
class CallMediaSession {
  MeteredPeer? _peer;
  MediaStream? _localStream;
  bool _closed = false;

  final List<StreamSubscription<dynamic>> _peerSubscriptions = [];
  final Map<String, List<StreamSubscription<dynamic>>> _remoteSubscriptions =
      {};
  final StreamController<MediaStream?> _remoteStreams =
      StreamController.broadcast();
  final StreamController<bool> _reconnecting = StreamController.broadcast();

  /// The other party's media; null when they leave. Re-emits a fresh stream
  /// object after a reconnect, so renderers must re-bind on every event.
  Stream<MediaStream?> get remoteStreams => _remoteStreams.stream;

  /// True while the signalling connection is recovering from a drop.
  Stream<bool> get reconnecting => _reconnecting.stream;

  MediaStream? get localStream => _localStream;

  /// Throws [CallException] when the microphone or camera is unavailable.
  Future<MediaStream> start({
    required String apiKey,
    required String channelId,
    required bool video,
  }) async {
    final MediaStream local;
    try {
      local = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': video ? {'facingMode': 'user'} : false,
      });
    } catch (e) {
      debugPrint('getUserMedia failed: $e');
      throw CallException(
        video
            ? 'Allow camera and microphone access to make video calls.'
            : 'Allow microphone access to make calls.',
      );
    }
    if (_closed) {
      await _release(local);
      throw const CallException('The call was closed.');
    }
    _localStream = local;
    await setSpeakerOn(video);

    final peer = MeteredPeer(MeteredPeerOptions(apiKey: apiKey));
    _peer = peer;
    _peerSubscriptions
      ..add(peer.onPeerJoined.listen(_onPeerJoined))
      ..add(peer.onPeerLeft.listen(_onPeerLeft))
      ..add(
        peer.stateChanges.listen((change) {
          if (change.to == MeteredPeerState.reconnecting) {
            _emit(_reconnecting, true);
          } else if (change.to == MeteredPeerState.joined) {
            _emit(_reconnecting, false);
          }
        }),
      )
      ..add(peer.onError.listen((e) => debugPrint('Call peer error: $e')));

    // Publishing before join saves a renegotiation round trip per peer.
    await peer.addStream(wrapMediaStream(local), metadata: {'role': 'camera'});
    await peer.join(channelId);
    return local;
  }

  void _onPeerJoined(RemotePeer remote) {
    _remoteSubscriptions[remote.id] = [
      remote.onStreamAdded.listen((event) {
        final stream = event.stream;
        if (stream is FlutterWebrtcMediaStream) {
          _emit(_remoteStreams, stream.native);
        }
      }),
      remote.onStreamRemoved.listen((_) => _emit(_remoteStreams, null)),
    ];
  }

  void _onPeerLeft(RemotePeer remote) {
    for (final subscription in _remoteSubscriptions.remove(remote.id) ?? []) {
      subscription.cancel();
    }
    _emit(_remoteStreams, null);
  }

  void _emit<T>(StreamController<T> controller, T value) {
    if (!controller.isClosed) controller.add(value);
  }

  void setMicrophoneEnabled(bool enabled) {
    for (final track
        in _localStream?.getAudioTracks() ?? <MediaStreamTrack>[]) {
      track.enabled = enabled;
    }
  }

  void setCameraEnabled(bool enabled) {
    for (final track
        in _localStream?.getVideoTracks() ?? <MediaStreamTrack>[]) {
      track.enabled = enabled;
    }
  }

  Future<void> setSpeakerOn(bool on) async {
    try {
      await Helper.setSpeakerphoneOn(on);
    } catch (e) {
      debugPrint('Speakerphone toggle failed: $e');
    }
  }

  Future<void> switchCamera() async {
    final track = _localStream?.getVideoTracks().firstOrNull;
    if (track != null) await Helper.switchCamera(track);
  }

  Future<void> close({String? callId}) async {
    if (_closed) return;
    _closed = true;
    for (final subscription in [
      ..._peerSubscriptions,
      for (final list in _remoteSubscriptions.values) ...list,
    ]) {
      await subscription.cancel();
    }
    _remoteSubscriptions.clear();
    // peer.close() doesn't stop capture; release the camera first so the
    // capture indicator turns off promptly.
    final local = _localStream;
    _localStream = null;
    if (local != null) await _release(local);
    try {
      await _peer?.close();
    } catch (e) {
      debugPrint('Closing call peer failed: $e');
    }
    try {
      await CallNativeService.clearLockScreenFlags();
    } catch (e) {
      debugPrint('Clearing lock-screen flags failed: $e');
    }
    await _remoteStreams.close();
    await _reconnecting.close();
  }

  Future<void> _release(MediaStream stream) async {
    for (final track in stream.getTracks()) {
      await track.stop();
    }
    await stream.dispose();
  }
}
