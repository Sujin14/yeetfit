import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';
import 'steps_goal_dialogue.dart';

class StepsActionSheet extends ConsumerWidget {
  final String userId;

  const StepsActionSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors['lightBackground'],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.colors['gray']!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Set Steps Goal',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 18.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['primaryText'],
            ),
          ),
          SizedBox(height: 16.h),
          ListTile(
            leading: Icon(Icons.flag, color: AppTheme.colors['teal']),
            title: Text(
              'Set Steps Goal',
              style: GoogleFonts.roboto(
                fontSize: isDesktop ? 16.sp : 16.sp,
                color: AppTheme.colors['primaryText'],
              ),
            ),
            onTap: () {
              // Create the controller here and pass it to the dialog
              final controller = TextEditingController(
                text: ref.read(stepsGoalInitialValueProvider(userId)),
              );
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) =>
                    StepsGoalDialog(userId: userId, controller: controller),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
