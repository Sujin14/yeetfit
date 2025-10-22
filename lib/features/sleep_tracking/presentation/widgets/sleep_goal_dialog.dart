import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/sleep_provider.dart';

// Dialog for setting sleep goal.
class SleepGoalDialog extends ConsumerWidget {
  final String userId;

  const SleepGoalDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepGoalDialogStateProvider(userId));

    return AlertDialog(
      backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.3),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Sleep Goal (hours)',
        style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: AppTheme.colors['white']),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: state.controller,
          decoration: InputDecoration(
            fillColor: AppTheme.colors['white']!.withOpacity(0.6),
            filled: true,
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: GoogleFonts.roboto(color: AppTheme.colors['white']!.withOpacity(0.7)),
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
          onPressed: () => state.submitGoal(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.8)),
          child: Text('Save', style: GoogleFonts.roboto(color: AppTheme.colors['white'])),
        ),
      ],
    );
  }
}