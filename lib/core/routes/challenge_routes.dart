import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/challenges/domain/entities/challenge.dart';
import 'package:yeetfit/features/challenges/presentation/screens/challenge_detail_screen.dart';
import 'package:yeetfit/features/challenges/presentation/screens/challenges_screen.dart';
import 'challenge_route_constants.dart';

// Routes for community challenges, pushed above the shell.
List<GoRoute> get challengeRoutes => [
  GoRoute(
    path: ChallengeRouteConstants.root,
    builder: (context, state) => const ChallengesScreen(),
  ),
  GoRoute(
    path: ChallengeRouteConstants.detail,
    redirect: (context, state) =>
        state.extra is Challenge ? null : ChallengeRouteConstants.root,
    builder: (context, state) =>
        ChallengeDetailScreen(challenge: state.extra as Challenge),
  ),
];
