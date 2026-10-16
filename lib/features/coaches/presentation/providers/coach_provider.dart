import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/coach_datasource.dart';
import '../../data/repositories/coach_repository_impl.dart';
import '../../domain/entities/coach.dart';
import '../../domain/repositories/coach_repository.dart';

final coachRepositoryProvider = Provider<CoachRepository>(
  (ref) => CoachRepositoryImpl(dataSource: CoachDataSource()),
);

/// Live: follows coaches being added, removed or (de)activated.
final activeCoachesProvider = StreamProvider.autoDispose<List<Coach>>(
  (ref) => ref.read(coachRepositoryProvider).watchActiveCoaches(),
);

final coachSearchQueryProvider =
    NotifierProvider.autoDispose<CoachSearchQuery, String>(
      CoachSearchQuery.new,
    );

class CoachSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Active coaches narrowed by the search query.
final filteredCoachesProvider = Provider.autoDispose<AsyncValue<List<Coach>>>((
  ref,
) {
  final query = ref.watch(coachSearchQueryProvider);
  return ref
      .watch(activeCoachesProvider)
      .whenData(
        (coaches) => coaches.where((coach) => coach.matches(query)).toList(),
      );
});

/// `null` when the client has no coach yet.
final currentCoachIdProvider = StreamProvider.autoDispose
    .family<String?, String>(
      (ref, clientUid) =>
          ref.read(coachRepositoryProvider).watchCurrentCoachId(clientUid),
    );

/// The assigned coach's profile; `null` when none is assigned or the
/// profile no longer exists. Follows changes to `currentCoachId`.
final currentCoachProvider = FutureProvider.autoDispose.family<Coach?, String>((
  ref,
  clientUid,
) async {
  final coachId = await ref.watch(currentCoachIdProvider(clientUid).future);
  if (coachId == null) return null;
  return ref.read(coachRepositoryProvider).getCoach(coachId);
});

typedef CoachRequestKey = ({String clientUid, String coachId});

final pendingCoachRequestProvider = StreamProvider.autoDispose
    .family<bool, CoachRequestKey>(
      (ref, key) => ref
          .read(coachRepositoryProvider)
          .watchHasPendingRequest(
            clientUid: key.clientUid,
            coachId: key.coachId,
          ),
    );

/// Sending a request to one coach; loading while it is in flight.
final coachRequestControllerProvider = AsyncNotifierProvider.autoDispose
    .family<CoachRequestController, void, String>(CoachRequestController.new);

class CoachRequestController extends AsyncNotifier<void> {
  final String coachId;

  CoachRequestController(this.coachId);

  @override
  FutureOr<void> build() {}

  /// Returns whether the request was sent. The caller shows the outcome, so
  /// a coach card and detail screen open at once don't both report it.
  Future<bool> request(String clientUid) async {
    if (state.isLoading) return false;
    final repository = ref.read(coachRepositoryProvider);
    state = const AsyncLoading();
    try {
      await repository.requestCoach(clientUid: clientUid, coachId: coachId);
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      debugPrint('Coach request failed: $e');
      if (ref.mounted) state = AsyncError(e, stackTrace);
      return false;
    }
  }
}

/// Removing the client's current coach; loading while the call is running.
final coachRemovalControllerProvider =
    AsyncNotifierProvider.autoDispose<CoachRemovalController, void>(
      CoachRemovalController.new,
    );

class CoachRemovalController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns `null` on success, otherwise a user-facing error message.
  /// The coach state itself is the live `clients/{uid}` listener, which
  /// clears as soon as the server commits the removal.
  Future<String?> remove() async {
    if (state.isLoading) return 'Already removing your coach.';
    final repository = ref.read(coachRepositoryProvider);
    state = const AsyncLoading();
    try {
      await repository.removeCoach();
      if (ref.mounted) state = const AsyncData(null);
      return null;
    } catch (e, stackTrace) {
      debugPrint('Coach removal failed: $e');
      if (ref.mounted) state = AsyncError(e, stackTrace);
      return e is CoachRemovalException
          ? e.message
          : 'Could not remove your coach. Please try again.';
    }
  }
}
