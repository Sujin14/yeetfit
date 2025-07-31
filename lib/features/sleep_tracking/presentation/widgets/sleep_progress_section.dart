import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../widgets/sleep_goal_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepProgressSection extends StatelessWidget {
  final double duration;
  final double goalHours;
  final Color progressColor;

  const SleepProgressSection({
    super.key,
    required this.duration,
    required this.goalHours,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

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
                  fontSize: 20,
                  color: AppTheme.colors['onSurface']!.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.colors['onSurface']),
                onPressed: userId != null
                    ? () => showDialog(
                          context: context,
                          builder: (context) => SleepGoalDialog(userId: userId),
                        )
                    : null,
                tooltip: 'Set Sleep Goal',
              ),
            ],
          ),
          TweenAnimationBuilder(
            tween: ColorTween(begin: AppTheme.colors['gray'], end: progressColor),
            duration: const Duration(milliseconds: 300),
            builder: (context, color, child) => LinearProgressIndicator(
              borderRadius: BorderRadius.circular(25),
              value: goalHours > 0 ? duration / goalHours : 0.0,
              minHeight: 10,
              color: color,
              backgroundColor: AppTheme.colors['white']!.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}