import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Auto-disposed so a revisit (welcome → onboarding → back → onboarding)
// starts on page 0 with a fresh PageController. State is the current page.
final onboardingControllerProvider =
    NotifierProvider.autoDispose<OnboardingController, int>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<int> {
  static const int pageCount = 3;

  final PageController pageController = PageController();

  @override
  int build() {
    ref.onDispose(pageController.dispose);
    return 0;
  }

  bool get isLastPage => state >= pageCount - 1;

  void onPageChanged(int index) => state = index;

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> preloadImages(BuildContext context) async {
    const assets = [
      'assets/images/onboarding1.webp',
      'assets/images/onboarding2.webp',
      'assets/images/onboarding3.webp',
    ];
    for (final asset in assets) {
      if (!context.mounted) return;
      await precacheImage(AssetImage(asset), context);
    }
  }
}
