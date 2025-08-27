import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_goal_dialog.dart';

class SleepProgressSection extends ConsumerWidget {
  const SleepProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    final today = DateTime.now().toIso8601String().split('T')[0];
    final duration = ref.watch(sleepDurationProvider(userId!).select((value) => value.value ?? 0.0));
    final goalHours = ref.watch(sleepGoalProvider(userId).select((value) => value.value ?? 8.0));
    final progressColor = ref.watch(dailySleepProgressColorProvider('$userId|$today'));

    return GlassmorphicContainer(
      color: AppTheme.colors['waterChartBackground']!,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${duration.toStringAsFixed(1)}h of ${goalHours.toStringAsFixed(1)}h',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.colors['onSurface']),
                onPressed: () => showDialog(
                          context: context,
                          builder: (context) => SleepGoalDialog(userId: userId),
                        ),
                tooltip: 'Set Sleep Goal',
              ),
            ],
          ),
          TweenAnimationBuilder(
            tween: ColorTween(begin: AppTheme.colors['gray'], end: progressColor),
            duration: const Duration(milliseconds: 300),
            builder: (context, color, child) => LinearProgressIndicator(
              borderRadius: BorderRadius.circular(25.r),
              value: goalHours > 0 ? duration / goalHours : 0.0,
              minHeight: 10.h,
              color: color,
              backgroundColor: AppTheme.colors['white']!.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}