import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (userId == null) return const SizedBox.shrink();

    final sleepTimesAsync = ref.watch(sleepTimesProvider(userId));

    return sleepTimesAsync.when(
      data: (sleepTimes) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Time',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppTheme.colors['onSurface']!.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 30.h),
          _buildTimeCard(
            context,
            'Bed Time',
            sleepTimes['bedtime'] != null
                ? DateFormat('h:mm a').format(sleepTimes['bedtime']!)
                : 'Not set',
            userId,
          ),
          SizedBox(height: 25.h),
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
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    String time,
    String userId,
  ) {
    return GlassmorphicContainer(
      color: AppTheme.colors['deepOrange']!,
      child: ListTile(
        onTap: () => showDialog(
          context: context,
          builder: (context) => SleepEntryDialog(userId: userId),
        ),
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 16.sp, color: AppTheme.colors['onSurface']!),
        ),
        trailing: Text(
          time,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppTheme.colors['onSurface']!.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}