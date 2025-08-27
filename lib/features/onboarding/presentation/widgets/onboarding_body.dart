import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
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

          // Skip button
          if (controller.currentPage < 2)
            Positioned(
              top: kIsWeb
                  ? FixedSizes.spacing(context) * 2.5
                  : FixedSizes.spacing(context) * 2,
              right: kIsWeb
                  ? FixedSizes.spacing(context) * 2.5
                  : FixedSizes.spacing(context) * 2,
              child: TextButton(
                onPressed: () => context.go('/welcome'),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: kIsWeb
                        ? FixedSizes.font18(context)
                        : FixedSizes.font16(context),
                  ),
                ),
              ),
            ),

          // Dots indicator
          Positioned(
            bottom: kIsWeb
                ? FixedSizes.spacing(context) * 6
                : FixedSizes.spacing(context) * 5,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = index == controller.currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: kIsWeb
                        ? FixedSizes.spacing(context) / 2
                        : FixedSizes.spacing(context) / 3,
                  ),
                  height: kIsWeb
                      ? FixedSizes.box16(context)
                      : FixedSizes.box12(context),
                  width: isActive
                      ? (kIsWeb
                          ? FixedSizes.box32(context)
                          : FixedSizes.box24(context))
                      : (kIsWeb
                          ? FixedSizes.box16(context)
                          : FixedSizes.box12(context)),
                  decoration: BoxDecoration(
                    color: AppTheme.colors['orangeAccent'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),

          // Next/Get Started button
          Positioned(
            bottom: kIsWeb
                ? FixedSizes.spacing(context) * 2.5
                : FixedSizes.spacing(context) * 2,
            right: kIsWeb
                ? FixedSizes.spacing(context) * 2.5
                : FixedSizes.spacing(context) * 2,
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
                style: TextStyle(
                  fontSize: kIsWeb
                      ? FixedSizes.font18(context)
                      : FixedSizes.font16(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
