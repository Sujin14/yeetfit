import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/theme.dart';

class DietDetailsWidget extends StatelessWidget {
  final List<dynamic> meals;

  const DietDetailsWidget({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals available',
          style:
              AppTheme.textStyles['body']?.copyWith(
                color: AppTheme.colors['secondaryText'] ?? Colors.grey,
                fontSize: 16.sp,
              ) ??
              TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index] as Map<String, dynamic>;
        final foods = meal['foods'] as List<dynamic>? ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal ${index + 1}: ${meal['name'] ?? 'Unnamed'}',
              style:
                  AppTheme.textStyles['subheading']?.copyWith(
                    color: AppTheme.colors['primaryText'] ?? Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            ...foods.asMap().entries.map((entry) {
              final food = entry.value as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${food['name'] ?? 'Unknown'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['primaryText'] ?? Colors.black,
                            fontSize: 16.sp,
                          ) ??
                          TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    Text(
                      'Quantity: ${food['quantity'] ?? 'N/A'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['secondaryText'] ?? Colors.grey,
                            fontSize: 14.sp,
                          ) ??
                          TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    Text(
                      'Calories: ${food['calories'] ?? 'N/A'}',
                      style:
                          AppTheme.textStyles['body']?.copyWith(
                            color:
                                AppTheme.colors['secondaryText'] ?? Colors.grey,
                            fontSize: 14.sp,
                          ) ??
                          TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    if (food['description'] != null &&
                        food['description'].isNotEmpty)
                      Text(
                        'Description: ${food['description']}',
                        style:
                            AppTheme.textStyles['body']?.copyWith(
                              color:
                                  AppTheme.colors['secondaryText'] ??
                                  Colors.grey,
                              fontSize: 14.sp,
                            ) ??
                            TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
