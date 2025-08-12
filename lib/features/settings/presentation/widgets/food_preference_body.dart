import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/settings_provider.dart';

class FoodPreferencesBody extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final String? dietPreference;
  final Map<String, bool> allergies;
  final String? otherAllergy;
  final Map<String, bool> cuisines;
  final TextEditingController otherAllergyController;
  final ValueChanged<String?> onDietPreferenceChanged;
  final Function(String, bool?) onAllergyChanged;
  final ValueChanged<String> onOtherAllergyChanged;
  final Function(String, bool?) onCuisineChanged;

  const FoodPreferencesBody({
    super.key,
    required this.formKey,
    required this.dietPreference,
    required this.allergies,
    required this.otherAllergy,
    required this.cuisines,
    required this.otherAllergyController,
    required this.onDietPreferenceChanged,
    required this.onAllergyChanged,
    required this.onOtherAllergyChanged,
    required this.onCuisineChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return settingsState.when(
      data: (_) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/diet_image.jpeg',
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.h),
              Divider(color: AppTheme.colors['borderGradientStart']),
              SizedBox(height: 16.h),
              Text(
                'Diet Preference',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: 18.sp,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: dietPreference,
                decoration: InputDecoration(
                  labelText: 'Diet Preference',
                  labelStyle: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['secondaryText'],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                items: ['Vegetarian', 'Non-Vegetarian', 'Vegan']
                    .map((diet) => DropdownMenuItem(value: diet, child: Text(diet)))
                    .toList(),
                onChanged: onDietPreferenceChanged,
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Any Allergies?',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: 18.sp,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              ...allergies.keys.map(
                (allergy) => CheckboxListTile(
                  title: Text(
                    allergy,
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  value: allergies[allergy],
                  onChanged: (value) => onAllergyChanged(allergy, value),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (allergies['Others']!)
                TextFormField(
                  controller: otherAllergyController,
                  decoration: InputDecoration(
                    labelText: 'Specify Other Allergy',
                    labelStyle: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['secondaryText'],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                  ),
                  onChanged: onOtherAllergyChanged,
                ),
              SizedBox(height: 16.h),
              Divider(color: AppTheme.colors['borderGradientStart']),
              SizedBox(height: 16.h),
              Text(
                'Preferred Cuisine',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: 18.sp,
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              ...cuisines.keys.map(
                (cuisine) => CheckboxListTile(
                  title: Text(
                    cuisine,
                    style: AppTheme.textStyles['body']!.copyWith(
                      color: AppTheme.colors['primaryText'],
                    ),
                  ),
                  value: cuisines[cuisine],
                  onChanged: (value) => onCuisineChanged(cuisine, value),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['error'],
                        minimumSize: Size(150.w, 48.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTheme.textStyles['body']!.copyWith(
                          color: AppTheme.colors['onSurfaceDark'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () => ref.read(settingsControllerProvider.notifier).saveFoodPreferences(
                                context: context,
                                dietPreference: dietPreference,
                                allergies: allergies,
                                otherAllergy: otherAllergy,
                                cuisines: cuisines,
                                formKey: formKey,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['primaryButton'],
                        minimumSize: Size(150.w, 48.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: isSaving
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: AppTheme.colors['onSurfaceDark'],
                              ),
                            )
                          : Text(
                              'Save',
                              style: AppTheme.textStyles['body']!.copyWith(
                                color: AppTheme.colors['onSurfaceDark'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ),
    );
  }
}