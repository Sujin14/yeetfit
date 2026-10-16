import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import '../../domain/entities/scanned_meal.dart';
import '../providers/meal_scan_provider.dart';
import 'meal_scan_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Prominent entry point to the AI meal scanner on the Nutrition screen.
class MealScanBanner extends ConsumerWidget {
  final Future<bool?> Function(ScannedMeal meal) onScanned;

  const MealScanBanner({super.key, required this.onScanned});

  static const double _radius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isScanning = ref.watch(mealScanControllerProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isScanning
            ? null
            : () => MealScanButton.startScan(context, ref, onScanned),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Stack(
            children: [
              GlassCard(
                borderRadius: _radius,
                padding: const EdgeInsets.fromLTRB(19, 14, 16, 14),
                child: Row(
                  children: [
                    isScanning
                        ? SizedBox.square(
                            dimension: 24,
                            child: Center(
                              child: ButtonSpinner(color: colors.secondary),
                            ),
                          )
                        : Icon(
                            Icons.camera_alt_outlined,
                            size: 24,
                            color: colors.secondary,
                          ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isScanning
                                ? 'Analysing your meal…'
                                : 'Scan your meal',
                            style: textTheme.titleMedium!.copyWith(
                              color: colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Let AI count the calories',
                            style: textTheme.bodySmall!.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.textMuted),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.primary, colors.secondary],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
