import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/sleep_provider.dart';

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
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: FixedSizes.font18(context),
          color: AppTheme.colors['white'],
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(FixedSizes.box16(context)),
        child: TextField(
          controller: state.controller,
          decoration: InputDecoration(
            fillColor: AppTheme.colors['white']!.withOpacity(0.6),
            filled: true,
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['white']!.withOpacity(0.7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FixedSizes.radius10(context)),
              borderSide: BorderSide(
                color: AppTheme.colors['white']!.withOpacity(0.3),
              ),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.roboto(
              fontSize: FixedSizes.font14(context),
              color: AppTheme.colors['white']),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['white']),
          ),
        ),
        ElevatedButton(
          onPressed: () => state.submitGoal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.8),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.roboto(
                fontSize: FixedSizes.font14(context),
                color: AppTheme.colors['white']),
          ),
        ),
      ],
    );
  }
}
