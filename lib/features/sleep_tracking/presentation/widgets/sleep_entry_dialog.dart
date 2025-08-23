import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: AppTheme.colors['deepOrange']!.withOpacity(0.4),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Add Sleep Entry',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: AppTheme.colors['white']!,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Bed Time',
              style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
            ),
            trailing: Text(
              state.bedtime != null
                  ? DateFormat('h:mm a').format(state.bedtime!)
                  : 'Select',
              style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
            ),
            onTap: () => state.pickBedtime(context),
          ),
          ListTile(
            title: Text(
              'Wake Up Time',
              style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
            ),
            trailing: Text(
              state.wakeUpTime != null
                  ? DateFormat('h:mm a').format(state.wakeUpTime!)
                  : 'Select',
              style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
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
            style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
          ),
        ),
        ElevatedButton(
          onPressed: () => state.submitSleepEntry(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors['navBarActive']!.withOpacity(0.6),
          ),
          child: Text('Add', style: GoogleFonts.roboto(color: AppTheme.colors['white']!)),
        ),
      ],
    );
  }
}