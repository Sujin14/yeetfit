import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weight_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'weight_goal_dialog.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightGoalSection extends ConsumerWidget {
  const WeightGoalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final goalAsync = ref.watch(weightGoalProvider(userId ?? ''));

    return GlassmorphicContainer(
      color: AppTheme.colors['teal']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Goal',
                style: GoogleFonts.roboto(
                  fontSize: FixedSizes.font18(context),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors['onSurface'],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppTheme.colors['onSurface'],
                  size: FixedSizes.icon20(context),
                ),
                onPressed: userId != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => WeightGoalDialog(userId: userId),
                        );
                      }
                    : null,
                tooltip: 'Edit Goal',
              ),
            ],
          ),
          SizedBox(height: FixedSizes.box8(context)),
          goalAsync.when(
            data: (goal) {
              final targetDate =
                  goal.targetDate ?? DateTime.now().add(const Duration(days: 180));
              return Text(
                'Target: ${goal.goalWeight.toStringAsFixed(1)} kg by ${targetDate.day}/${targetDate.month}/${targetDate.year}',
                style: GoogleFonts.roboto(
                  fontSize: FixedSizes.font14(context),
                  color: AppTheme.colors['onSurface']!.withOpacity(0.7),
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text(
              'Error loading goal: $error',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['onSurface']!.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
