import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Network-interface status. This reports whether a connection (Wi-Fi,
/// mobile, ethernet, VPN...) exists, not whether the internet is reachable.
class ConnectivityService {
  static final _connectivity = Connectivity();

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);

  /// Emits the current status first, then every change.
  /// `onConnectivityChanged` alone only fires on changes, so starting offline
  /// would never surface.
  static Stream<bool> get onlineStream async* {
    yield await isOnline;
    yield* _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  static Future<bool> get isOnline async =>
      _hasConnection(await _connectivity.checkConnectivity());
}

final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.onlineStream;
});
