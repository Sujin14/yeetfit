import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class BMISuggestions extends StatelessWidget {
  final String category;
  final String suggestion;

  const BMISuggestions({
    super.key,
    required this.category,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'BMI Category: $category\nRecommendation: $suggestion',
      style: AppTheme.textStyles['body']!.copyWith(
        fontSize: 16.sp,
        color: AppTheme.colors['secondaryText'],
      ),
    );
  }
}
