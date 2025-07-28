import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'steps_goal.dart';

class StepsProgressCard extends StatelessWidget {
  final int steps;
  final int goalSteps;
  final Color progressColor;

  const StepsProgressCard({
    super.key,
    required this.steps,
    required this.goalSteps,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$steps of $goalSteps steps walked',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors['primaryText']!.withOpacity(0.8),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 18.sp, color: AppTheme.colors['onSurface']),
                onPressed: userId != null
                    ? () => showDialog(
                          context: context,
                          builder: (context) => StepsGoalDialog(userId: userId),
                        )
                    : null,
                tooltip: 'Set Steps Goal',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TweenAnimationBuilder(
            tween: ColorTween(begin: AppTheme.colors['gray'], end: progressColor),
            duration: const Duration(milliseconds: 300),
            builder: (context, color, child) => ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: LinearProgressIndicator(
                value: goalSteps > 0 ? steps / goalSteps : 0.0,
                color: color,
                backgroundColor: AppTheme.colors['white']!.withOpacity(0.2),
                minHeight: 8.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}