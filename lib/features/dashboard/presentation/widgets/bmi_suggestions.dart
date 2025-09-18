import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/dashboard_provider.dart';
import 'welcome_text.dart';

class BMISuggestions extends ConsumerWidget {
  final AsyncValue<Map<String, dynamic>?> userData;
  final String userId;

  const BMISuggestions({
    super.key,
    required this.userData,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiAsync = ref.watch(bmiStreamProvider(userId));

    return bmiAsync.when(
      data: (bmi) {
        final bmiColor = ref.watch(bmiColorProvider(bmi));
        final bmiCategory = ref.watch(bmiCategoryProvider(bmi));
        final bmiSuggestion = ref.watch(bmiSuggestionProvider(bmi));

        return Container(
          height: 280.h,
          width: double.infinity,
          color: bmiColor.withOpacity(0.3),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userData.when(
                    data: (u) => WelcomeText(name: u?['name'] ?? 'User'),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e', style: AppTheme.textStyles['body']),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your BMI: ${bmi.toStringAsFixed(1)}',
                    style: AppTheme.textStyles['heading']!.copyWith(
                      fontSize: 24.sp,
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'BMI Category: $bmiCategory\nRecommendation: $bmiSuggestion',
                    style: AppTheme.textStyles['body']!.copyWith(
                      fontSize: 16.sp,
                      color: AppTheme.colors['secondaryText'],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
