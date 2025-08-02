import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/sleep_provider.dart';

class SleepEntryDialog extends ConsumerStatefulWidget {
  final String userId;

  const SleepEntryDialog({super.key, required this.userId});

  @override
  ConsumerState<SleepEntryDialog> createState() => _SleepEntryDialogState();
}

class _SleepEntryDialogState extends ConsumerState<SleepEntryDialog> {
  DateTime? bedtime;
  DateTime? wakeUpTime;

  @override
  Widget build(BuildContext context) {
    final sleepTimesAsync = ref.watch(sleepTimesProvider(widget.userId));
    bedtime ??= sleepTimesAsync.value?['bedtime'];
    wakeUpTime ??= sleepTimesAsync.value?['wakeUpTime'];

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
                bedtime != null
                    ? DateFormat('h:mm a').format(bedtime!)
                    : 'Select',
                style: GoogleFonts.roboto(color: AppTheme.colors['white']!),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    bedtime ?? DateTime.now(),
                  ),
                );
                if (time != null) {
                  setState(() {
                    bedtime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                'Wake Up Time',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              trailing: Text(
                wakeUpTime != null
                    ? DateFormat('h:mm a').format(wakeUpTime!)
                    : 'Select',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    wakeUpTime ?? DateTime.now(),
                  ),
                );
                if (time != null) {
                  setState(() {
                    wakeUpTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      time.hour,
                      time.minute,
                    );
                    if (bedtime != null && wakeUpTime!.hour < bedtime!.hour) {
                      wakeUpTime = wakeUpTime!.add(const Duration(days: 1));
                    }
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (bedtime != null && wakeUpTime != null) {
                DateTime adjustedWakeUpTime = wakeUpTime!;
                if (wakeUpTime!.isBefore(bedtime!) ||
                    wakeUpTime!.isAtSameMomentAs(bedtime!)) {
                  adjustedWakeUpTime = wakeUpTime!.add(const Duration(days: 1));
                }

                final duration =
                    adjustedWakeUpTime.difference(bedtime!).inMinutes / 60.0;

                ref
                    .read(sleepTimesProvider(widget.userId).notifier)
                    .addSleepEntry(bedtime!, adjustedWakeUpTime, duration);

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please select both bedtime and wake-up time',
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['navBarActive']!.withOpacity(0.6),
            ),
            child: Text('Add', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
    );
  }
}
