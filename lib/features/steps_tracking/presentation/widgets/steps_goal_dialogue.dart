import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';

class StepsGoalDialog extends ConsumerStatefulWidget {
  final String userId;
  final TextEditingController controller;

  const StepsGoalDialog({
    super.key,
    required this.userId,
    required this.controller,
  });

  @override
  _StepsGoalDialogState createState() => _StepsGoalDialogState();
}

class _StepsGoalDialogState extends ConsumerState<StepsGoalDialog> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.colors['lightBackground'],
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Steps Goal',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: FixedSizes.font18(context),
          color: AppTheme.colors['primaryText']!.withOpacity(0.8),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: FixedSizes.spacing(context),
          vertical: FixedSizes.box4(context),
        ),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: 'Enter goal steps (e.g., 10000)',
            hintStyle: GoogleFonts.roboto(
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              fontSize: FixedSizes.font14(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FixedSizes.radius10(context)),
              borderSide: BorderSide(
                color: AppTheme.colors['primaryText']!.withOpacity(0.8),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          style: GoogleFonts.roboto(
            color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            fontSize: FixedSizes.font14(context),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['primaryText']!.withOpacity(0.8),
              fontSize: FixedSizes.font14(context),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(widget.controller.text);
            if (newGoal != null && newGoal > 0) {
              ref
                  .read(stepsGoalProvider(widget.userId).notifier)
                  .setGoal(newGoal);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid number')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['teal']!.withOpacity(0.3),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.roboto(
              color: AppTheme.colors['white'],
              fontSize: FixedSizes.font14(context),
            ),
          ),
        ),
      ],
    );
  }
}
