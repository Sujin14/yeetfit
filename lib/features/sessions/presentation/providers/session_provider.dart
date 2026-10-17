import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/services/notification_service.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import '../../data/datasources/session_datasource.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/entities/new_training_session.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepositoryImpl(SessionDataSource()),
);

typedef SessionWatchKey = ({String? coachId, String? currentUserId});

final upcomingSessionsProvider =
    StreamProvider.autoDispose.family<List<TrainingSession>, SessionWatchKey>((
      ref,
      key,
    ) {
      if (key.coachId == null) return Stream.value(const []);
      return ref
          .read(sessionRepositoryProvider)
          .watchUpcomingSessions(
            coachId: key.coachId,
            currentUserId: key.currentUserId,
          );
    });

/// Ticks every minute so "Live" chips and "in 2h" countdowns stay current.
final sessionClockProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

/// Sessions that haven't ended yet at the current clock tick.
final visibleSessionsProvider = Provider.autoDispose
    .family<AsyncValue<List<TrainingSession>>, SessionWatchKey>((ref, key) {
      final now = ref.watch(sessionClockProvider).value ?? DateTime.now();
      return ref
          .watch(upcomingSessionsProvider(key))
          .whenData(
            (sessions) => sessions
                .where((session) => session.endsAt.isAfter(now))
                .toList(),
          );
    });

/// Schedules a session as the signed-in coach and notifies members.
final createSessionControllerProvider =
    AsyncNotifierProvider.autoDispose<CreateSessionController, void>(
      CreateSessionController.new,
    );

class CreateSessionController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns whether the session was created; on failure [state] holds the
  /// error. A failed notification doesn't fail the whole submit.
  Future<bool> submit(NewTrainingSession session) async {
    if (state.isLoading) return false;
    final userId = ref.read(authUserIdProvider);
    if (userId == null) return false;
    final repository = ref.read(sessionRepositoryProvider);
    final notifications = ref.read(notificationServiceProvider);

    state = const AsyncLoading();
    try {
      final sessionId = await repository.createSession(
        trainerId: userId,
        session: session,
      );
      try {
        await notifications.notifyNewSession(sessionId);
      } catch (e) {
        debugPrint('New session notification failed: $e');
      }
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      debugPrint('Creating session failed: $e');
      if (ref.mounted) state = AsyncError(e, stack);
      return false;
    }
  }

  /// Returns whether the session was deleted.
  Future<bool> delete(String sessionId) async {
    final repository = ref.read(sessionRepositoryProvider);
    try {
      await repository.deleteSession(sessionId);
      return true;
    } catch (e) {
      debugPrint('Deleting session failed: $e');
      return false;
    }
  }
}

/// Ids of sessions with a reminder pending on this device.
final sessionReminderControllerProvider =
    AsyncNotifierProvider.autoDispose<SessionReminderController, Set<String>>(
      SessionReminderController.new,
    );

class SessionReminderController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() =>
      ref.read(notificationServiceProvider).pendingSessionReminderIds();

  /// Returns false when the session starts too soon for a reminder.
  Future<bool> remind(TrainingSession session) async {
    final scheduled = await ref
        .read(notificationServiceProvider)
        .scheduleSessionReminder(
          sessionId: session.id,
          title: session.title,
          startsAt: session.scheduledAt,
        );
    if (scheduled && ref.mounted) {
      state = AsyncData({...?state.value, session.id});
    }
    return scheduled;
  }
}
