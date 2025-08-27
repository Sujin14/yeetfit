// features/dashboard/presentation/widgets/bmi_suggestions.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/dashboard_provider.dart';
import 'welcome_text.dart';

class BMISuggestions extends ConsumerWidget {
  final double bmi;
  final AsyncValue<Map<String, dynamic>?> userData;
  final String userId;

  const BMISuggestions({
    super.key,
    required this.bmi,
    required this.userData,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmiColor = ref.watch(bmiColorProvider(bmi));
    final bmiCategory = ref.watch(bmiCategoryProvider(bmi));
    final bmiSuggestion = ref.watch(bmiSuggestionProvider(bmi));

    return Container(
      height: FixedSizes.box100(context) * 2.8, // close to 280.h
      width: double.infinity,
      color: bmiColor.withOpacity(0.3),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.box16(context),
            vertical: FixedSizes.box12(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userData.when(
                data: (u) => WelcomeText(name: u?['name'] ?? 'User'),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e', style: AppTheme.textStyles['body']),
              ),
              SizedBox(height: FixedSizes.box12(context)),
              Text(
                'Your BMI: ${bmi.toStringAsFixed(1)}',
                style: AppTheme.textStyles['heading']!.copyWith(
                  fontSize: FixedSizes.font22(context),
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              Text(
                'BMI Category: $bmiCategory\nRecommendation: $bmiSuggestion',
                style: AppTheme.textStyles['body']!.copyWith(
                  fontSize: FixedSizes.font16(context),
                  color: AppTheme.colors['secondaryText'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
