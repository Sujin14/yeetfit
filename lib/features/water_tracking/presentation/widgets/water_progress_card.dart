import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../providers/water_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterProgressCard extends StatelessWidget {
  final int glassesConsumed;
  final int goalGlasses;

  const WaterProgressCard({
    super.key,
    required this.glassesConsumed,
    required this.goalGlasses,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive']!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$glassesConsumed / $goalGlasses Glasses',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.colors['primaryText']!.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: userId != null
                    ? () => _showEditGoalDialog(context, userId)
                    : null,
                icon: Icon(Icons.edit, size: 20, color: AppTheme.colors['primaryText']!.withOpacity(0.7),),
                tooltip: 'Edit Goal',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                value: goalGlasses > 0 ? glassesConsumed / goalGlasses : 0.0,
                minHeight: 18,
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.colors['aquaBlue'],
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '${goalGlasses > 0 ? ((glassesConsumed / goalGlasses) * 100).toInt() : 0}%',
                  style: GoogleFonts.roboto(fontSize: 14, color: AppTheme.colors['white']),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, String userId) {
    final controller = TextEditingController(text: goalGlasses.toString());
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) => AlertDialog(
          title: const Text('Edit Water Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Glasses per Day',
              hintText: 'Enter number of glasses',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newGoal = int.tryParse(controller.text);
                if (newGoal != null && newGoal > 0) {
                  ref.read(waterGoalProvider(userId).notifier).setGoal(newGoal);
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}