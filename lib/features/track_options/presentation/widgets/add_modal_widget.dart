import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/drag_handle.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/track_button.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/routes/tracking_routes_constants.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AddModalWidget extends StatelessWidget {
  const AddModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    void open(String route) => context.push(route);

    return GlassCard(
      color: colors.background,
      opacity: 0.2,
      blurStrength: 10,
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 24,
      border: Border.all(color: colors.secondary.withValues(alpha: 0.25)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DragHandle(),
            Text(
              'Track Your Progress',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TrackButton(
              icon: Icons.local_dining,
              label: 'Add Meal',
              color: colors.secondary,
              onTap: () => open(TrackingRouteConstants.calorieTracking),
            ),
            const SizedBox(height: AppSpacing.smd),
            TrackButton(
              icon: Icons.bed,
              label: 'Add Sleep',
              color: colors.secondary,
              onTap: () => open(TrackingRouteConstants.sleepTracking),
            ),
            const SizedBox(height: AppSpacing.smd),
            TrackButton(
              icon: Icons.directions_walk,
              label: 'Add Steps',
              color: colors.secondary,
              onTap: () => open(TrackingRouteConstants.stepCounter),
            ),
            const SizedBox(height: AppSpacing.smd),
            TrackButton(
              icon: Icons.water_drop,
              label: 'Add Water',
              color: colors.secondary,
              onTap: () => open(TrackingRouteConstants.waterTracking),
            ),
            const SizedBox(height: AppSpacing.smd),
            TrackButton(
              icon: Icons.scale,
              label: 'Add Weight',
              color: colors.secondary,
              onTap: () => open(TrackingRouteConstants.weightTracking),
            ),
          ],
        ),
      ),
    );
  }
}
