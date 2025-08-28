import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/sleep_provider.dart';

class SleepEntryDialog extends ConsumerWidget {
  final String userId;

  const SleepEntryDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepEntryDialogStateProvider(userId));

    return AlertDialog(
      backgroundColor: AppTheme.colors['cardBackground']!.withOpacity(0.4),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Add Sleep Entry',
        style: AppTheme.textStyles['subheading']!.copyWith(
          color: AppTheme.colors['onSurfaceDark'],
          fontSize: 18.sp,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Bed Time',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
                fontSize: 16.sp,
              ),
            ),
            trailing: Text(
              state.bedtime != null
                  ? DateFormat('h:mm a').format(state.bedtime!)
                  : 'Select',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
                fontSize: 16.sp,
              ),
            ),
            onTap: () => state.pickBedtime(context),
          ),
          ListTile(
            title: Text(
              'Wake Up Time',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
                fontSize: 16.sp,
              ),
            ),
            trailing: Text(
              state.wakeUpTime != null
                  ? DateFormat('h:mm a').format(state.wakeUpTime!)
                  : 'Select',
              style: AppTheme.textStyles['body']!.copyWith(
                color: AppTheme.colors['onSurfaceDark'],
                fontSize: 16.sp,
              ),
            ),
            onTap: () => state.pickWakeUpTime(context),
          ),
        ],
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
          onPressed: () => state.submitSleepEntry(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['primaryButton'],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Add',
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
