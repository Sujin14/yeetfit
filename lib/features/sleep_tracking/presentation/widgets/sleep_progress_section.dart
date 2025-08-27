import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_goal_dialog.dart';

class SleepProgressSection extends ConsumerWidget {
  const SleepProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) return const SizedBox.shrink();

    final today = DateTime.now().toIso8601String().split('T')[0];
    final duration = ref.watch(sleepDurationProvider(userId).select((v) => v.value ?? 0.0));
    final goalHours = ref.watch(sleepGoalProvider(userId).select((v) => v.value ?? 8.0));
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
                  fontSize: FixedSizes.font20(context),
                  color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                ),
              ),
              SizedBox(width: FixedSizes.box8(context)),
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.colors['onSurface']),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => SleepGoalDialog(userId: userId),
                ),
                tooltip: 'Set Sleep Goal',
              ),
            ],
          ),
          TweenAnimationBuilder(
            tween: ColorTween(begin: AppTheme.colors['gray'], end: progressColor),
            duration: const Duration(milliseconds: 300),
            builder: (context, color, child) => LinearProgressIndicator(
              borderRadius: BorderRadius.circular(FixedSizes.radius24(context)),
              value: goalHours > 0 ? duration / goalHours : 0.0,
              minHeight: FixedSizes.box10(context),
              color: color,
              backgroundColor: AppTheme.colors['white']!.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
