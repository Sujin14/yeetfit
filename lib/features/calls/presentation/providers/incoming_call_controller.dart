import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import '../../domain/repositories/call_repository.dart';
import 'call_provider.dart';

/// Answers or declines a ringing call, keyed by call id. Unanswered calls
/// are marked missed after [ringTimeout].
final incomingCallControllerProvider = AsyncNotifierProvider.autoDispose
    .family<IncomingCallController, void, String>(IncomingCallController.new);

class IncomingCallController extends AsyncNotifier<void> {
  static const Duration ringTimeout = Duration(seconds: 30);

  final String callId;

  IncomingCallController(this.callId);

  @override
  FutureOr<void> build() {
    final timer = Timer(ringTimeout, _markMissed);
    ref.onDispose(timer.cancel);
    ref
        .read(notificationServiceProvider)
        .dismissIncomingCallNotification(callId);
  }

  Future<void> _markMissed() async {
    try {
      await ref.read(callRepositoryProvider).markMissed(callId);
    } catch (e) {
      // Already answered, declined or cancelled.
      debugPrint('Marking call missed skipped: $e');
    }
  }

  Future<bool> accept() => _run((repository) => repository.acceptCall(callId));

  Future<bool> decline() =>
      _run((repository) => repository.declineCall(callId));

  Future<bool> _run(Future<void> Function(CallRepository) action) async {
    if (state.isLoading) return false;
    final repository = ref.read(callRepositoryProvider);
    state = const AsyncLoading();
    try {
      await action(repository);
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      debugPrint('Incoming call action failed: $e');
      if (ref.mounted) state = AsyncError(e, stack);
      return false;
    }
  }
}
