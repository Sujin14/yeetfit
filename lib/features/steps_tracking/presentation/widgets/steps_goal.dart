import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../providers/steps_provider.dart';

class StepsGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const StepsGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<StepsGoalDialog> createState() => _StepsGoalDialogState();
}

class _StepsGoalDialogState extends ConsumerState<StepsGoalDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final goalSteps = ref.read(stepsGoalProvider(widget.userId)).value ?? 10000;
    controller.text = goalSteps.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return AlertDialog(
      backgroundColor: AppTheme.colors['lightBackground'],
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Steps Goal',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: isDesktop ? 18.sp : 20.sp,
          color: AppTheme.colors['primaryText']!.withOpacity(0.8),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter goal steps (e.g., 10000)',
            hintStyle: GoogleFonts.roboto(
              color: AppTheme.colors['primaryText']!.withOpacity(0.7),
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: AppTheme.colors['primaryText']!.withOpacity(0.8),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          style: GoogleFonts.roboto(
            color: AppTheme.colors['primaryText']!.withOpacity(0.7),
            fontSize: isDesktop ? 14.sp : 16.sp,
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
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(controller.text);
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
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
          ),
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
