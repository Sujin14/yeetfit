import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> preloadImages(BuildContext context) async {
    for (final asset in [
      'assets/images/onboarding1.png',
      'assets/images/onboarding2.png',
      'assets/images/onboarding3.png',
    ]) {
      await precacheImage(AssetImage(asset), context);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
