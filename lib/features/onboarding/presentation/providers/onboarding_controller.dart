import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for onboarding page controller and state.
final onboardingControllerProvider =
    ChangeNotifierProvider<OnboardingController>((ref) {
      return OnboardingController();
    });

// Controller for onboarding page navigation and image preloading.
class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  // Handles page changes and notifies listeners.
  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  // Advances to the next page with animation.
  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // Preloads onboarding images for smooth rendering.
  Future<void> preloadImages(BuildContext context) async {
    const assets = [
      'assets/images/onboarding1.png',
      'assets/images/onboarding2.png',
      'assets/images/onboarding3.png',
    ];
    for (final asset in assets) {
      await precacheImage(AssetImage(asset), context);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}