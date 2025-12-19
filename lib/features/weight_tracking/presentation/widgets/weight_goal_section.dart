import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import 'weight_goal_dialog.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

/// Section for displaying and editing weight goal.
class WeightGoalSection extends ConsumerWidget {
  const WeightGoalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    final goalAsync = ref.watch(weightGoalProvider(userId ?? ''));

    return GlassmorphicContainer(
      color: AppTheme.colors['teal']!,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Goal',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors['onSurface'],
                ),
              ),
              if (userId != null)
                IconButton(
                  icon: Icon(Icons.edit, color: AppTheme.colors['onSurface'], size: 20.sp),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => WeightGoalDialog(userId: userId),
                  ),
                  tooltip: 'Edit Goal',
                ),
            ],
          ),
          SizedBox(height: 8.h),
          goalAsync.when(
            data: (goal) {
              final targetDate = goal.targetDate ?? DateTime.now().add(const Duration(days: 180));
              return Text(
                'Target: ${goal.goalWeight.toStringAsFixed(1)} kg by ${targetDate.day}/${targetDate.month}/${targetDate.year}',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                ),
              );
            },
            loading: () => const SizedBox.shrink(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Error loading goal: $error',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: AppTheme.colors['onSurface']!.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}