import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/call_exception.dart';
import '../../data/datasources/call_media_session.dart';
import '../../domain/entities/call_type.dart';
import '../utils/call_error_message.dart';
import 'active_call_state.dart';
import 'call_provider.dart';

typedef ActiveCallArgs = ({
  String callId,
  String channelId,
  CallType type,
  bool isCaller,
});

/// Media for an ongoing call. Joins on creation and tears everything down
/// (camera, microphone, peer connection, renderers) when the call screen
/// goes away.
final activeCallControllerProvider = NotifierProvider.autoDispose
    .family<ActiveCallController, ActiveCallState, ActiveCallArgs>(
      ActiveCallController.new,
    );

class ActiveCallController extends Notifier<ActiveCallState> {
  /// How long the caller waits for an answer before the call counts as
  /// missed. Matches the receiver's [IncomingCallController.ringTimeout].
  static const Duration ringTimeout = Duration(seconds: 30);

  final ActiveCallArgs args;

  ActiveCallController(this.args);

  late RTCVideoRenderer localRenderer;
  late RTCVideoRenderer remoteRenderer;
  late CallMediaSession _media;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Timer? _ringTimer;

  @override
  ActiveCallState build() {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
    _media = CallMediaSession();
    ref.onDispose(_teardown);
    // State can't be set synchronously inside build.
    Future.microtask(_start);
    return ActiveCallState(isSpeakerOn: args.type.isVideo);
  }

  Future<void> _start() async {
    final media = _media;
    _subscriptions
      ..add(media.remoteStreams.listen(_onRemoteStream))
      ..add(
        media.reconnecting.listen((reconnecting) {
          if (!ref.mounted || state.phase == CallConnectionPhase.failed) return;
          state = state.copyWith(
            phase: reconnecting
                ? CallConnectionPhase.reconnecting
                : _settledPhase(),
          );
        }),
      );
    if (args.isCaller) _ringTimer = Timer(ringTimeout, _onRingTimeout);

    try {
      await Future.wait([
        localRenderer.initialize(),
        remoteRenderer.initialize(),
      ]);
      final String apiKey;
      try {
        apiKey = await ref.read(meteredConfigProvider.future);
      } catch (_) {
        if (ref.mounted) ref.invalidate(meteredConfigProvider);
        rethrow;
      }
      if (!ref.mounted) return;

      final local = await media.start(
        apiKey: apiKey,
        channelId: args.channelId,
        video: args.type.isVideo,
      );
      if (!ref.mounted) return;
      if (args.type.isVideo) localRenderer.srcObject = local;
      if (state.phase == CallConnectionPhase.connecting) {
        state = state.copyWith(phase: _settledPhase());
      }
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('Joining call failed: $e');
      state = state.copyWith(
        phase: CallConnectionPhase.failed,
        error: callErrorMessage(e),
      );
      // Stop the other side ringing or waiting for media that won't come.
      _endCallInBackground();
    }
  }

  CallConnectionPhase _settledPhase() => state.hasRemoteStream
      ? CallConnectionPhase.connected
      : CallConnectionPhase.waiting;

  void _onRemoteStream(MediaStream? stream) {
    if (!ref.mounted) return;
    // Re-bind on every event: a reconnect delivers a fresh stream object.
    remoteRenderer.srcObject = stream;
    final hasStream = stream != null;
    if (hasStream) _ringTimer?.cancel();
    state = state.copyWith(
      hasRemoteStream: hasStream,
      phase: state.phase == CallConnectionPhase.failed
          ? CallConnectionPhase.failed
          : hasStream
          ? CallConnectionPhase.connected
          : CallConnectionPhase.waiting,
    );
  }

  Future<void> _onRingTimeout() async {
    try {
      await ref.read(callRepositoryProvider).markMissed(args.callId);
    } on CallException {
      // Answered (or ended) in the meantime.
    } catch (e) {
      debugPrint('Marking call missed failed: $e');
    }
  }

  /// Ends the call for both parties. The screen closes right away; the
  /// status write completes in the background.
  void hangUp() => _endCallInBackground();

  void _endCallInBackground() {
    final repository = ref.read(callRepositoryProvider);
    unawaited(
      repository.endCall(args.callId).catchError((Object e) {
        debugPrint('Ending call failed: $e');
      }),
    );
  }

  void toggleMute() {
    final muted = !state.isMuted;
    _media.setMicrophoneEnabled(!muted);
    state = state.copyWith(isMuted: muted);
  }

  void toggleCamera() {
    final cameraOff = !state.isCameraOff;
    _media.setCameraEnabled(!cameraOff);
    state = state.copyWith(isCameraOff: cameraOff);
  }

  Future<void> toggleSpeaker() async {
    final speakerOn = !state.isSpeakerOn;
    state = state.copyWith(isSpeakerOn: speakerOn);
    await _media.setSpeakerOn(speakerOn);
  }

  Future<void> switchCamera() => _media.switchCamera();

  void _teardown() {
    _ringTimer?.cancel();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    final media = _media;
    final local = localRenderer;
    final remote = remoteRenderer;
    unawaited(() async {
      await media.close(callId: args.callId);
      for (final renderer in [local, remote]) {
        try {
          if (renderer.textureId != null) renderer.srcObject = null;
          await renderer.dispose();
        } catch (e) {
          debugPrint('Disposing call renderer failed: $e');
        }
      }
    }());
  }
}
