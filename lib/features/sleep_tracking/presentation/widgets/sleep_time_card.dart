import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_entry_dialog.dart';

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
              fontSize: FixedSizes.font18(context),
              color: AppTheme.colors['onSurface']!.withOpacity(0.8),
            ),
          ),
          SizedBox(height: FixedSizes.box30(context)),
          _buildTimeCard(
            context,
            'Bed Time',
            sleepTimes['bedtime'] != null
                ? DateFormat('h:mm a').format(sleepTimes['bedtime']!)
                : 'Not set',
            userId,
          ),
          SizedBox(height: FixedSizes.box25(context)),
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
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Center(child: Text('Error: $e')),
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
          builder: (_) => SleepEntryDialog(userId: userId),
        ),
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: FixedSizes.font16(context),
            color: AppTheme.colors['onSurface']!,
          ),
        ),
        trailing: Text(
          time,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: FixedSizes.font16(context),
            color: AppTheme.colors['onSurface']!.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
