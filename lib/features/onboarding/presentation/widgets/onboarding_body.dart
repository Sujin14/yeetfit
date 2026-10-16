import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/pager_nav_bar.dart';
import '../providers/onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingBody extends ConsumerStatefulWidget {
  final VoidCallback onFinish;

  const OnboardingBody({super.key, required this.onFinish});

  @override
  ConsumerState<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends ConsumerState<OnboardingBody> {
  static const _pages = [
    OnboardingPage(
      imagePath: 'assets/images/onboarding1.webp',
      title: 'Track Your Fitness',
      description: 'Monitor calories, steps, sleep and water intake easily.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding2.webp',
      title: 'Custom Diet Plans',
      description: 'Get AI-based diet plans tailored to your goals.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding3.webp',
      title: 'Stay Motivated',
      description: 'Follow routines, track progress, and stay consistent.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(onboardingControllerProvider.notifier).preloadImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    // Images run under the status bar, so keep its icons light.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: _pages.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (_, index) => RepaintBoundary(child: _pages[index]),
            ),
          ),
          PagerNavBar(
            currentPage: currentPage,
            pageCount: _pages.length,
            finishLabel: 'Get Started',
            onSkip: widget.onFinish,
            onNext: controller.nextPage,
            onFinish: widget.onFinish,
          ),
        ],
      ),
    );
  }
}
