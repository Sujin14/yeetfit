import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/steps_provider.dart';

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
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return AlertDialog(
      backgroundColor: AppTheme.colors['cardBackground']!.withOpacity(0.4),
      contentPadding: EdgeInsets.all(16.w),
      title: Text(
        'Set Steps Goal',
        style: AppTheme.textStyles['subheading']!.copyWith(
          fontSize: isDesktop ? 18.sp : 20.sp,
          color: AppTheme.colors['onSurfaceDark'],
        ),
      ),
      content: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Enter goal steps (e.g., 10000)',
          hintStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
            fontSize: isDesktop ? 14.sp : 16.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppTheme.colors['borderGradientStart']!),
          ),
        ),
        keyboardType: TextInputType.number,
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['onSurfaceDark'],
          fontSize: isDesktop ? 14.sp : 16.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['error'],
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(widget.controller.text);
            if (newGoal != null && newGoal > 0) {
              ref.read(stepsGoalProvider(widget.userId).notifier).setGoal(newGoal);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Steps goal updated',
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  backgroundColor: AppTheme.colors['cardBackground'],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please enter a valid number',
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['error'],
                    ),
                  ),
                  backgroundColor: AppTheme.colors['cardBackground'],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['primaryButton'],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Save',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['onSurfaceDark'],
              fontWeight: FontWeight.w600,
              fontSize: isDesktop ? 14.sp : 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}