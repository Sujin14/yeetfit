import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/sleep_provider.dart';

class SleepGoalDialog extends ConsumerWidget {
  final String userId;

  const SleepGoalDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepGoalDialogStateProvider(userId));

    return AlertDialog(
      backgroundColor: AppTheme.colors['cardBackground']!.withOpacity(0.4),
      contentPadding: EdgeInsets.all(16.w),
      title: Text(
        'Set Sleep Goal (hours)',
        style: AppTheme.textStyles['subheading']!.copyWith(
          color: AppTheme.colors['onSurfaceDark'],
          fontSize: 18.sp,
        ),
      ),
      content: TextField(
        controller: state.controller,
        decoration: InputDecoration(
          fillColor: AppTheme.colors['cardBackground']!.withOpacity(0.6),
          filled: true,
          hintText: 'Enter hours (e.g., 7.5)',
          hintStyle: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.7),
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: AppTheme.colors['borderGradientStart']!,
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppTheme.textStyles['body']!.copyWith(
          color: AppTheme.colors['onSurfaceDark'],
          fontSize: 14.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.textStyles['body']!.copyWith(
              color: AppTheme.colors['error'],
              fontSize: 14.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            state.submitGoal(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sleep goal updated',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
                backgroundColor: AppTheme.colors['cardBackground'],
              ),
            );
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
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
