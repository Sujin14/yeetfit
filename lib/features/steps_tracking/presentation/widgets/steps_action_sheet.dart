import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/entry_dialog.dart';
import '../providers/steps_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import 'steps_goal_dialogue.dart';

class StepsActionSheet extends ConsumerWidget {
  final String userId;

  const StepsActionSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ScreenUtil().screenWidth >= 600.w;
    return GlassmorphicContainer(
      color: AppTheme.colors['cardBackground']!,
      borderRadius: 24.r,
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
            style: AppTheme.textStyles['subheading']!.copyWith(
              fontSize: isDesktop ? 18.sp : 20.sp,
              color: AppTheme.colors['onSurfaceDark'],
            ),
          ),
          SizedBox(height: 16.h),
          ListTile(
            leading: Icon(
              Icons.flag,
              color: AppTheme.colors['primaryIcon'],
              size: 24.sp,
            ),
            title: Text(
              'Set Steps Goal',
              style: AppTheme.textStyles['body']!.copyWith(
                fontSize: isDesktop ? 14.sp : 16.sp,
                color: AppTheme.colors['onSurfaceDark'],
              ),
            ),
            onTap: () {
              final controller = TextEditingController(
                text: ref.read(stepsGoalInitialValueProvider(userId)),
              );
              Navigator.pop(context);
              entryDialog(
                context: context,
                ref: ref,
                dialog: StepsGoalDialog(userId: userId, controller: controller),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}