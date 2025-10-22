import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/routes/onboarding_route_constants.dart';
import '../providers/onboarding_controller.dart';
import 'onboarding_indicators.dart';
import 'onboarding_page.dart';

// Main body for onboarding with PageView and controls.
class OnboardingBody extends ConsumerStatefulWidget {
  const OnboardingBody({super.key});

  @override
  ConsumerState<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends ConsumerState<OnboardingBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingControllerProvider.notifier).preloadImages(context);
    });
  }

  // Helper to get responsive values based on platform (web vs mobile).
  T _responsiveValue<T>(T webValue, T mobileValue) {
    return kIsWeb ? webValue : mobileValue;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(onboardingControllerProvider);

    const pages = [
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

    return SafeArea(
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (_, index) => RepaintBoundary(child: pages[index]),
          ),
          if (controller.currentPage < 2)
            Positioned(
              top: _responsiveValue(30.h, 20.h),
              right: _responsiveValue(30.w, 20.w),
              child: TextButton(
                onPressed: () => context.go(OnboardingRouteConstants.welcome),
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: _responsiveValue(18.sp, 16.sp).clamp(14.0, 18.0)),
                ),
              ),
            ),
          Positioned(
            bottom: _responsiveValue(80.h, 60.h),
            left: 0,
            right: 0,
            child: OnboardingIndicators(currentPage: controller.currentPage),
          ),
          Positioned(
            bottom: _responsiveValue(30.h, 20.h),
            right: _responsiveValue(30.w, 20.w),
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentPage < 2) {
                  controller.nextPage();
                } else {
                  context.go(OnboardingRouteConstants.welcome);
                }
              },
              child: Text(
                controller.currentPage < 2 ? 'Next' : 'Get Started',
                style: TextStyle(fontSize: _responsiveValue(18.sp, 16.sp).clamp(14.0, 18.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}