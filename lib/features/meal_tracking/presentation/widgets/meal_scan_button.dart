import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/button_spinner.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import '../../domain/entities/scanned_meal.dart';
import '../providers/meal_scan_provider.dart';
import 'meal_scan_source_sheet.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// App bar action that scans a meal photo with AI.
///
/// [onScanned] opens the result screen and completes with `true` when the
/// user asks to retake the photo.
class MealScanButton extends ConsumerWidget {
  final Future<bool?> Function(ScannedMeal meal) onScanned;

  const MealScanButton({super.key, required this.onScanned});

  /// Camera/gallery sheet → AI scan → result screen, repeated on "retake".
  /// Shared with [MealScanBanner].
  static Future<void> startScan(
    BuildContext context,
    WidgetRef ref,
    Future<bool?> Function(ScannedMeal meal) onScanned,
  ) async {
    final source = await MealScanSourceSheet.show(context);
    if (source == null || !context.mounted) return;

    final meal = await ref
        .read(mealScanControllerProvider.notifier)
        .scan(context, source);
    if (meal == null || !context.mounted) return;

    final retake = await onScanned(meal);
    if (retake == true && context.mounted) {
      await startScan(context, ref, onScanned);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isScanning = ref.watch(mealScanControllerProvider).isLoading;

    ref.listen(mealScanControllerProvider, (_, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.smd),
      child: isScanning
          ? SizedBox.square(
              dimension: 36,
              child: Center(child: ButtonSpinner(color: colors.primary)),
            )
          : GlassIconButton(
              icon: Icons.photo_camera_outlined,
              color: colors.onBackground,
              tooltip: 'Scan a meal photo',
              onPressed: () => startScan(context, ref, onScanned),
            ),
    );
  }
}
