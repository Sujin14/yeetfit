import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../../domain/entities/coach.dart';
import '../providers/coach_provider.dart';
import '../widgets/coach_detail_body.dart';

class CoachDetailScreen extends ConsumerWidget {
  final Coach coach;

  const CoachDetailScreen({super.key, required this.coach});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    // Prefer the live copy so profile edits made in YeetCoach show up.
    final current =
        ref
            .watch(activeCoachesProvider)
            .value
            ?.where((item) => item.uid == coach.uid)
            .firstOrNull ??
        coach;

    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to view this coach',
              )
            : CoachDetailBody(
                coach: current,
                clientUid: userId,
                currentCoachId: ref.watch(currentCoachIdProvider(userId)),
              ),
      ),
    );
  }
}
