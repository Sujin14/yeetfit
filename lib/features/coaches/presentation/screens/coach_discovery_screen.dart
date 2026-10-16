import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/coach_route_constants.dart';
import 'package:yeetfit/core/routes/shell_route_constants.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../providers/coach_provider.dart';
import '../widgets/coach_discovery_body.dart';

class CoachDiscoveryScreen extends ConsumerWidget {
  const CoachDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: userId == null
          ? const SignInRequiredView(message: 'Please log in to find a coach')
          : CoachDiscoveryBody(
              coaches: ref.watch(filteredCoachesProvider),
              clientUid: userId,
              currentCoachId: ref.watch(currentCoachIdProvider(userId)),
              searchQuery: ref.watch(coachSearchQueryProvider),
              onSearchChanged: ref
                  .read(coachSearchQueryProvider.notifier)
                  .update,
              onOpen: (coach) =>
                  context.push(CoachRouteConstants.detail, extra: coach),
              onRetry: () => ref.invalidate(activeCoachesProvider),
              onRefresh: () => ref.refresh(currentCoachProvider(userId).future),
              onCoachRemoved: () => context.go(ShellRouteConstants.coaches),
            ),
    );
  }
}
