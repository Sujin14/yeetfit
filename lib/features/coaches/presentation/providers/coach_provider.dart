import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/coach_datasource.dart';
import '../../data/repositories/coach_repository_impl.dart';
import '../../domain/entities/client_profile.dart';
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

/// Live `clients/{uid}` document for the signed-in client.
final clientProfileProvider = StreamProvider.autoDispose
    .family<ClientProfile, String>(
      (ref, clientUid) =>
          ref.read(coachRepositoryProvider).watchClientProfile(clientUid),
    );

/// Stream of this client's current star rating for a given coach.
/// Null if the client has not yet rated.
final clientRatingProvider = StreamProvider.autoDispose
    .family<int?, ({String coachUid, String clientUid})>((ref, key) {
      return FirebaseFirestore.instance
          .collection('coaches')
          .doc(key.coachUid)
          .collection('ratings')
          .doc(key.clientUid)
          .snapshots()
          .map((snap) {
            if (!snap.exists) return null;
            final s = snap.data()?['stars'];
            return s is num ? s.toInt() : null;
          });
    });

/// Writes or updates this client's star rating for a coach.
Future<void> submitCoachRating({
  required String coachUid,
  required String clientUid,
  required int stars,
}) {
  assert(stars >= 1 && stars <= 5);
  return FirebaseFirestore.instance
      .collection('coaches')
      .doc(coachUid)
      .collection('ratings')
      .doc(clientUid)
      .set({'stars': stars, 'updatedAt': FieldValue.serverTimestamp()});
}

/// `null` when the client has no coach yet.
final currentCoachIdProvider = StreamProvider.autoDispose
    .family<String?, String>(
      (ref, clientUid) =>
          ref.read(coachRepositoryProvider).watchCurrentCoachId(clientUid),
    );

/// Live `coaches/{coachId}` profile; `null` when missing / inactive / disabled.
final coachProfileProvider = StreamProvider.autoDispose.family<Coach?, String>(
  (ref, coachId) => ref.watch(coachRepositoryProvider).watchCoach(coachId),
);

/// The assigned coach's profile; `null` when none is assigned or the
/// profile no longer exists. Follows changes to `currentCoachId`.
///
/// Prefer [myCoachProvider] for UI that must distinguish none vs unavailable
/// without calling `.future` on auto-dispose providers.
final currentCoachProvider = Provider.autoDispose.family<AsyncValue<Coach?>, String>((
  ref,
  clientUid,
) {
  final coachIdAsync = ref.watch(currentCoachIdProvider(clientUid));
  return coachIdAsync.when(
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
    data: (coachId) {
      if (coachId == null || coachId.isEmpty) {
        return const AsyncData(null);
      }
      return ref.watch(coachProfileProvider(coachId));
    },
  );
});

/// Coach identity shown in chat / gate UI.
class MyCoach {
  final String id;
  final String name;
  final String? photoUrl;

  const MyCoach({
    required this.id,
    required this.name,
    required this.photoUrl,
  });
}

/// Result of resolving the client's assigned coach for chat.
sealed class MyCoachState {
  const MyCoachState();
}

class MyCoachLoading extends MyCoachState {
  const MyCoachLoading();
}

class MyCoachNone extends MyCoachState {
  const MyCoachNone();
}

class MyCoachUnavailable extends MyCoachState {
  const MyCoachUnavailable();
}

class MyCoachReady extends MyCoachState {
  final MyCoach coach;

  const MyCoachReady(this.coach);
}

/// Watches [currentCoachIdProvider] then the coach profile doc. Never uses
/// `.future` so auto-dispose cannot throw mid-load.
final myCoachProvider = Provider.autoDispose.family<MyCoachState, String>((
  ref,
  clientUid,
) {
  final coachIdAsync = ref.watch(currentCoachIdProvider(clientUid));
  return coachIdAsync.when(
    loading: () => const MyCoachLoading(),
    error: (_, _) => const MyCoachUnavailable(),
    data: (coachId) {
      if (coachId == null || coachId.isEmpty) return const MyCoachNone();
      final profileAsync = ref.watch(coachProfileProvider(coachId));
      return profileAsync.when(
        loading: () => const MyCoachLoading(),
        error: (_, _) => const MyCoachUnavailable(),
        data: (coach) {
          if (coach == null) return const MyCoachUnavailable();
          return MyCoachReady(
            MyCoach(
              id: coach.uid,
              name: coach.name,
              photoUrl: coach.profileImageUrl,
            ),
          );
        },
      );
    },
  );
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
