import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_entry_dialog.dart';
import 'sleep_time_card_shimmer.dart';

class SleepTimeCards extends ConsumerWidget {
  const SleepTimeCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return Center(
        child: Text(
          'Please log in to view sleep times',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['error'],
            fontSize: 14.sp,
          ),
        ),
      );
    }

    final sleepTimesAsync = ref.watch(sleepTimesProvider(userId));

    return sleepTimesAsync.when(
      data: (sleepTimes) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Time',
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: 18.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: AppTheme.colors['borderGradientStart']),
          SizedBox(height: 16.h),
          _buildTimeCard(
            context,
            'Bed Time',
            sleepTimes['bedtime'] != null
                ? DateFormat('h:mm a').format(sleepTimes['bedtime']!)
                : 'Not set',
            userId,
          ),
          SizedBox(height: 16.h),
          _buildTimeCard(
            context,
            'Wake Up Time',
            sleepTimes['wakeUpTime'] != null
                ? DateFormat('h:mm a').format(sleepTimes['wakeUpTime']!)
                : 'Not set',
            userId,
          ),
        ],
      ),
      loading: () => const SleepTimeCardsShimmer(),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['error'],
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    String time,
    String userId,
  ) {
    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        onTap: () => showDialog(
          context: context,
          builder: (context) => SleepEntryDialog(userId: userId),
        ),
        title: Text(
          title,
          style: AppTheme.textStyles['body']!.copyWith(
            fontSize: 16.sp,
            color: AppTheme.colors['onSurfaceDark'],
          ),
        ),
        trailing: Text(
          time,
          style: AppTheme.textStyles['body']!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
