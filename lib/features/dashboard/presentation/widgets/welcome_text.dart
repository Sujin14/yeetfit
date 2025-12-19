import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class WelcomeText extends StatelessWidget {
  final String name;
  const WelcomeText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      'Welcome, $name!',
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 28.sp, color: colors.onBackground.withOpacity(0.9)),
    );
  }
}