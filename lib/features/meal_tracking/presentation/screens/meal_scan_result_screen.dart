import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/launch_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../../domain/entities/scanned_meal.dart';
import '../widgets/scan_result_form.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Pops with `true` when the user wants to retake the photo.
class MealScanResultScreen extends ConsumerWidget {
  final ScannedMeal result;

  const MealScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);

    return LaunchGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(message: 'Please log in to log meals')
            : CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  const GlassSliverAppBar(title: 'Scan Result'),
                  SliverToBoxAdapter(
                    child: ScanResultForm(
                      userId: userId,
                      result: result,
                      onRetake: () => context.pop(true),
                      onAdded: (mealType) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to $mealType')),
                        );
                        context.pop(false);
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
              ),
      ),
    );
  }
}
