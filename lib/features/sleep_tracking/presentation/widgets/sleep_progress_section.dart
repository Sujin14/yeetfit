import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${duration.toStringAsFixed(1)}h of ${goalHours.toStringAsFixed(1)}h',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 12 : 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
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
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(25),
            value: goalHours > 0 ? duration / goalHours : 0.0,
            minHeight: isDesktop ? 16 : 10,
            color: progressColor,
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}