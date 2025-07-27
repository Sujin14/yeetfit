import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../widgets/sleep_entry_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepTimeCards extends StatelessWidget {
  final DateTime? bedtime;
  final DateTime? wakeUpTime;

  const SleepTimeCards({super.key, this.bedtime, this.wakeUpTime});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep Time',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 14 : 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        _buildTimeCard(
          context,
          'Bed Time',
          bedtime != null ? DateFormat('h:mm a').format(bedtime!) : 'Not set',
          userId,
        ),
        SizedBox(height: 20.h),
        _buildTimeCard(
          context,
          'Wake Up Time',
          wakeUpTime != null
              ? DateFormat('h:mm a').format(wakeUpTime!)
              : 'Not set',
          userId,
        ),
      ],
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    String time,
    String? userId,
  ) {
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: ListTile(
        onTap: userId != null
            ? () => showDialog(
                context: context,
                builder: (context) => SleepEntryDialog(userId: userId),
              )
            : null,
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
        ),
        trailing: Text(
          time,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
