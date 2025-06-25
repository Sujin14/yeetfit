import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../shared/theme/app_text_styles.dart';

class LoginOptionsDivider extends StatelessWidget {
  const LoginOptionsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text("or continue with", style: AppTextStyles.body),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
