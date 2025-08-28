import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/onboarding_page.dart';

final onboardingControllerProvider = ChangeNotifierProvider<OnboardingController>((ref) {
  return OnboardingController();
});

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<OnboardingPage> pages = const [
    OnboardingPage(
      imagePath: 'assets/images/onboarding1.png',
      title: 'Track Your Fitness',
      description: 'Monitor calories, steps, sleep and water intake easily.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding2.png',
      title: 'Custom Diet Plans',
      description: 'Get AI-based diet plans tailored to your goals.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding3.png',
      title: 'Stay Motivated',
      description: 'Follow routines, track progress, and stay consistent.',
    ),
  ];

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> preloadImages(BuildContext context) async {
    for (final page in pages) {
      await precacheImage(AssetImage(page.imagePath), context);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}