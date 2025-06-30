import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/theme.dart';
import 'gradient_text.dart';

class AddModal extends StatelessWidget {
  const AddModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 400.h,
      borderRadius: 20.r,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.colors['lightBackground']!.withOpacity(0.2),
          AppTheme.colors['lightBackground']!.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppTheme.colors['borderText']!.withOpacity(0.3),
          AppTheme.colors['borderText']!.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientText(
                  text: 'Add New',
                  style: AppTheme.textStyles['heading']!.copyWith(
                    fontSize: 24.sp,
                  ),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.yellow, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppTheme.colors['darkText']),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Add feature coming soon!',
              style: AppTheme.textStyles['subtitle']!.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors['primaryButton'],
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Close',
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
