import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/sleep_provider.dart';

class SleepGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const SleepGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<SleepGoalDialog> createState() => _SleepGoalDialogState();
}

class _SleepGoalDialogState extends ConsumerState<SleepGoalDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final goalHours = ref.read(sleepGoalProvider(widget.userId)).value;
    controller.text = goalHours.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.3),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Sleep Goal (hours)',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: AppTheme.colors['white'],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: AppTheme.colors['white']!.withOpacity(0.6),
            filled: true,
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: GoogleFonts.roboto(
              color: AppTheme.colors['white']!.withOpacity(0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.colors['white']!.withOpacity(0.3)),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.roboto(color: AppTheme.colors['white']),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.roboto(color: AppTheme.colors['white'])),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = double.tryParse(controller.text);
            if (newGoal != null && newGoal > 0) {
              ref
                  .read(sleepGoalProvider(widget.userId).notifier)
                  .setGoal(newGoal);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid number')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.8),
          ),
          child: Text('Save', style: GoogleFonts.roboto(color: AppTheme.colors['white'])),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
