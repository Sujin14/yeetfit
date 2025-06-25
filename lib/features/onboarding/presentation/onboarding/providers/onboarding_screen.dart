import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../application/controllers/onboarding_controller.dart';
import '../../widgets/onboarding_body.dart';

final onboardingControllerProvider =
    ChangeNotifierProvider<OnboardingController>((ref) {
      return OnboardingController();
    });

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: OnboardingBody());
  }
}
