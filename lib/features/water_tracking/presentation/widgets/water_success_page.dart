import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

// Success page for daily water goal.
class WaterSuccessPage extends StatelessWidget {
  final int goal;

  const WaterSuccessPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
            repeat: false,
          ),
          Text(
            'Congratulations! 🎉',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 28,
              color: colors.primary,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'You crushed your goal of $goal glasses today — let’s keep the streak alive! 💧',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 18,
                color: colors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(TrackingRouteConstants.waterTracking),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.smd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Done',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
