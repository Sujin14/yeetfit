import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepTimeCards extends StatelessWidget {
  const SleepTimeCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep Time',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 6 : 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        _buildTimeCard(context, 'Bed Time', '10:00 PM'),
        SizedBox(height: 20.h,),
        _buildTimeCard(context, 'Wake Up Time', '6:00 AM'),
      ],
    );
  }

  Widget _buildTimeCard(BuildContext context, String title, String time) {
    return GlassmorphicContainer(
      color: const Color(0xFFFF5722),
      child: ListTile(
        onTap: () {},
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.white,
          ),
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
