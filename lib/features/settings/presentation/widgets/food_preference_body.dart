import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/settings_provider.dart';
import 'package:go_router/go_router.dart';

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
        padding: EdgeInsets.symmetric(
          horizontal: FixedSizes.box24(context),
          vertical: FixedSizes.box24(context),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/diet_image.jpeg',
                height: FixedSizes.box150(context),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: FixedSizes.box16(context)),
              Divider(color: AppTheme.colors['borderGradientStart']),
              SizedBox(height: FixedSizes.box16(context)),
              Text(
                'Diet Preference',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.font18(context),
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: FixedSizes.box8(context)),
              DropdownButtonFormField<String>(
                value: dietPreference,
                decoration: InputDecoration(
                  labelText: 'Diet Preference',
                  labelStyle: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['secondaryText'],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      FixedSizes.radius8(context),
                    ),
                  ),
                ),
                items: ['Vegetarian', 'Non-Vegetarian', 'Vegan']
                    .map(
                      (diet) =>
                          DropdownMenuItem(value: diet, child: Text(diet)),
                    )
                    .toList(),
                onChanged: onDietPreferenceChanged,
                style: AppTheme.textStyles['body']!.copyWith(
                  color: AppTheme.colors['primaryText'],
                ),
              ),
              SizedBox(height: FixedSizes.box16(context)),
              Text(
                'Any Allergies?',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.font18(context),
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
                      borderRadius: BorderRadius.circular(
                        FixedSizes.radius8(context),
                      ),
                    ),
                  ),
                  style: AppTheme.textStyles['body']!.copyWith(
                    color: AppTheme.colors['primaryText'],
                  ),
                  onChanged: onOtherAllergyChanged,
                ),
              SizedBox(height: FixedSizes.box16(context)),
              Divider(color: AppTheme.colors['borderGradientStart']),
              SizedBox(height: FixedSizes.box16(context)),
              Text(
                'Preferred Cuisine',
                style: AppTheme.textStyles['subtitle']!.copyWith(
                  fontSize: FixedSizes.font18(context),
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
              SizedBox(height: FixedSizes.box24(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['error'],
                        minimumSize: Size.square(FixedSizes.buttonSize(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FixedSizes.radius8(context),
                          ),
                        ),
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
                  SizedBox(width: FixedSizes.box16(context)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () => ref
                                .read(settingsControllerProvider.notifier)
                                .saveFoodPreferences(
                                  context: context,
                                  dietPreference: dietPreference,
                                  allergies: allergies,
                                  otherAllergy: otherAllergy,
                                  cuisines: cuisines,
                                  formKey: formKey,
                                ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['primaryButton'],
                        minimumSize: Size.square(FixedSizes.buttonSize(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FixedSizes.radius8(context),
                          ),
                        ),
                      ),
                      child: isSaving
                          ? SizedBox(
                              width: FixedSizes.box24(context),
                              height: FixedSizes.box24(context),
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
