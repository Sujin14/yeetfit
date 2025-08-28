import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/onboarding_provider.dart';

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

    return SafeArea(
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (_, index) => RepaintBoundary(child: controller.pages[index]),
          ),
          if (controller.currentPage < controller.pages.length - 1)
            Positioned(
              top: kIsWeb ? 30.h : 20.h,
              right: kIsWeb ? 30.w : 20.w,
              child: TextButton(
                onPressed: () => context.go('/welcome'),
                child: Text(
                  "Skip",
                  style: AppTheme.textStyles['bodyMedium']!.copyWith(
                    color: AppTheme.colors['onSurface'],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: kIsWeb ? 80.h : 60.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.pages.length, (index) {
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
                if (controller.currentPage < controller.pages.length - 1) {
                  controller.nextPage();
                } else {
                  context.go('/welcome');
                }
              },
              child: Text(
                controller.currentPage < controller.pages.length - 1 ? 'Next' : 'Get Started',
                style: AppTheme.textStyles['bodyMedium']!.copyWith(
                  color: AppTheme.colors['onSurface'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}