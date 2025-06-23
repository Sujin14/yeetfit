import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_controller.dart';
import 'onboarding_page.dart';
import '../phone_auth_screen.dart'; // to be implemented

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OnboardingController>(context);

    final pages = [
      const OnboardingPage(
        imagePath: 'assets/images/onboarding1.png',
        title: 'Track Your Fitness',
        description: 'Monitor calories, steps, sleep and water intake easily.',
      ),
      const OnboardingPage(
        imagePath: 'assets/images/onboarding2.png',
        title: 'Custom Diet Plans',
        description: 'Get AI-based diet plans tailored to your goals.',
      ),
      const OnboardingPage(
        imagePath: 'assets/images/onboarding3.png',
        title: 'Stay Motivated',
        description: 'Follow routines, track progress, and stay consistent.',
      ),
    ];

    return Stack(
      children: [
        PageView.builder(
          controller: controller.pageController,
          itemCount: pages.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (_, index) => pages[index],
        ),
        Positioned(
          top: 40,
          right: 20,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
              );
            },
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
                );
              }
            },
            child: Text(controller.currentPage < 2 ? 'Next' : 'Get Started'),
          ),
        ),
      ],
    );
  }
}
