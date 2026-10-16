import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import '../../data/datasources/call_exception.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_type.dart';
import 'call_provider.dart';

/// Places outgoing calls; loading while a call is being created.
final callLauncherProvider =
    AsyncNotifierProvider.autoDispose<CallLauncher, void>(CallLauncher.new);

class CallLauncher extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns the ringing call, or null on failure (the error is in [state]).
  Future<CallSession?> start({
    required CallParticipant receiver,
    required CallType type,
  }) async {
    if (state.isLoading) return null;
    final userId = ref.read(authUserIdProvider);
    if (userId == null || userId == receiver.id) {
      state = AsyncError(
        const CallException('You can only call your coach.'),
        StackTrace.current,
      );
      return null;
    }

    final repository = ref.read(callRepositoryProvider);
    state = const AsyncLoading();
    try {
      final caller = await repository.getParticipant(userId);
      final call = await repository.initiateCall(
        caller: caller,
        receiver: receiver,
        type: type,
      );
      if (ref.mounted) state = const AsyncData(null);
      return call;
    } catch (e, stack) {
      debugPrint('Starting call failed: $e');
      if (ref.mounted) state = AsyncError(e, stack);
      return null;
    }
  }
}
