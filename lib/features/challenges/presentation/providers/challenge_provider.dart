import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasources/challenge_datasource.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/challenge_participant.dart';

final challengeDataSourceProvider = Provider<ChallengeDataSource>(
  (ref) => ChallengeDataSource(),
);

final activeChallengesProvider = StreamProvider.autoDispose<List<Challenge>>(
  (ref) => ref.read(challengeDataSourceProvider).watchActiveChallenges(),
);

final challengeLeaderboardProvider = StreamProvider.autoDispose
    .family<List<ChallengeParticipant>, String>(
      (ref, challengeId) =>
          ref.read(challengeDataSourceProvider).watchLeaderboard(challengeId),
    );

final myProgressProvider = StreamProvider.autoDispose
    .family<ChallengeParticipant?, ({String cId, String uId})>(
      (ref, args) => ref
          .read(challengeDataSourceProvider)
          .watchMyProgress(args.cId, args.uId),
    );

/// Join/leave state per challenge; loading while a request is in flight.
final challengeMembershipControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ChallengeMembershipController, void, String>(
      ChallengeMembershipController.new,
    );

class ChallengeMembershipController extends AsyncNotifier<void> {
  final String challengeId;

  ChallengeMembershipController(this.challengeId);

  ChallengeDataSource get _dataSource => ref.read(challengeDataSourceProvider);

  @override
  FutureOr<void> build() {}

  Future<void> join(String userId) {
    final dataSource = _dataSource;
    return _run(() => dataSource.joinChallenge(challengeId, userId));
  }

  Future<void> leave(String userId) {
    final dataSource = _dataSource;
    return _run(() => dataSource.leaveChallenge(challengeId, userId));
  }

  Future<void> _run(Future<void> Function() action) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await action();
      if (ref.mounted) state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('Challenge membership update failed: $e');
      if (ref.mounted) state = AsyncError(e, stack);
    }
  }
}
