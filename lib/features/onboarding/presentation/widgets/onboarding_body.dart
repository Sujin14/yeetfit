import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingBody extends ConsumerWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              top: 20.h,
              right: 20.h,
              child: TextButton(
                onPressed: () => context.go('/welcome'),
                child: const Text("Skip"),
              ),
            ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = index == controller.currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 20 : 8,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentPage < 2) {
                  controller.nextPage();
                } else {
                  context.go('/welcome');
                }
              },
              child: Text(controller.currentPage < 2 ? 'Next' : 'Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}
