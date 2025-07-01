import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Explore Content Coming Soon!',
        style: AppTheme.textStyles['body']!.copyWith(
          fontSize: 18.sp,
          color: AppTheme.colors['primaryText'],
        ),
      ),
    );
  }
}
