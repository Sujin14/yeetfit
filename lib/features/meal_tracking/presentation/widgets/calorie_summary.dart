import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalorieSummary extends ConsumerWidget {
  final double totalCalories;
  final double goalCalories;
  final Color progressColor;

  const CalorieSummary({
    super.key,
    required this.totalCalories,
    required this.goalCalories,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: goalCalories > 0 ? totalCalories / goalCalories : 0.0,
                  strokeWidth: 6,
                  backgroundColor: AppTheme.colors['white']!.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
              ),
              Icon(
                Icons.local_dining,
                size: 28,
                color: AppTheme.colors['indigo'],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${totalCalories.toStringAsFixed(0)} of ${goalCalories.toStringAsFixed(0)} Cal',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors['onSurface'],
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.push('/weekly-calorie-chart');
            },
            child: Icon(
              Icons.bar_chart,
              color: AppTheme.colors['indigo'],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}