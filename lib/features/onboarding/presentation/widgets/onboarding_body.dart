import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../providers/onboarding_controller.dart';
import 'onboarding_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(onboardingControllerProvider);

    final pages = const [
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
              top: kIsWeb ? 30.h : 20.h,
              right: kIsWeb ? 30.w : 20.w,
              child: TextButton(
                onPressed: () => context.go('/welcome'),
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: (kIsWeb ? 18.sp : 16.sp).clamp(14.0, 18.0)),
                ),
              ),
            ),
          Positioned(
            bottom: kIsWeb ? 80.h : 60.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = index == controller.currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 6.w : 4.w),
                  height: kIsWeb ? 10.h : 8.h,
                  width: isActive ? (kIsWeb ? 24.w : 20.w) : (kIsWeb ? 10.w : 8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.colors['orangeAccent'],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: kIsWeb ? 30.h : 20.h,
            right: kIsWeb ? 30.w : 20.w,
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentPage < 2) {
                  controller.nextPage();
                } else {
                  context.go('/welcome');
                }
              },
              child: Text(
                controller.currentPage < 2 ? 'Next' : 'Get Started',
                style: TextStyle(fontSize: (kIsWeb ? 18.sp : 16.sp).clamp(14.0, 18.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}