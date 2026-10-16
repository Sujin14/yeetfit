import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../providers/settings_provider.dart';
import 'settings_chip_group.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class FoodPreferencesForm extends ConsumerStatefulWidget {
  final UserInfoModel? userInfo;

  const FoodPreferencesForm({super.key, required this.userInfo});

  @override
  ConsumerState<FoodPreferencesForm> createState() =>
      _FoodPreferencesFormState();
}

class _FoodPreferencesFormState extends ConsumerState<FoodPreferencesForm> {
  static const _diets = ['Vegetarian', 'Non-Vegetarian', 'Vegan'];
  static const _otherAllergyKey = 'Others';

  late String? _dietPreference;
  final Map<String, bool> _allergies = {
    'Dairy': false,
    'Seafood': false,
    'Nuts': false,
    'Lamb/Mutton': false,
    _otherAllergyKey: false,
  };
  final Map<String, bool> _cuisines = {
    'North Indian': false,
    'South Indian': false,
    'Continental': false,
    'Chinese': false,
  };
  late final TextEditingController _otherAllergyController;

  @override
  void initState() {
    super.initState();
    final userInfo = widget.userInfo;
    _dietPreference = userInfo?.dietPreference ?? _diets.first;
    _allergies.addAll(userInfo?.allergies ?? const {});
    _cuisines.addAll(userInfo?.cuisines ?? const {});
    _otherAllergyController = TextEditingController(
      text: userInfo?.otherAllergy ?? '',
    );
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      final selected = !(_allergies[allergy] ?? false);
      _allergies[allergy] = selected;
      if (allergy == _otherAllergyKey && !selected) {
        _otherAllergyController.clear();
      }
    });
  }

  void _save() {
    FocusScope.of(context).unfocus();
    ref
        .read(settingsControllerProvider.notifier)
        .saveFoodPreferences(
          dietPreference: _dietPreference,
          allergies: _allergies,
          otherAllergy: _otherAllergyController.text,
          cuisines: _cuisines,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsChipGroup(
                  label: 'Diet preference',
                  options: _diets,
                  isSelected: (diet) => _dietPreference == diet,
                  onTap: (diet) => setState(() => _dietPreference = diet),
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsChipGroup(
                  label: 'Any allergies?',
                  options: _allergies.keys.toList(),
                  isSelected: (allergy) => _allergies[allergy] ?? false,
                  onTap: _toggleAllergy,
                ),
                if (_allergies[_otherAllergyKey] ?? false) ...[
                  const SizedBox(height: AppSpacing.smd),
                  YeetTextField(
                    controller: _otherAllergyController,
                    hintText: 'Specify other allergy',
                    prefixIcon: Icons.edit_note_rounded,
                    textInputAction: TextInputAction.done,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SettingsChipGroup(
                  label: 'Preferred cuisine',
                  options: _cuisines.keys.toList(),
                  isSelected: (cuisine) => _cuisines[cuisine] ?? false,
                  onTap: (cuisine) => setState(
                    () => _cuisines[cuisine] = !(_cuisines[cuisine] ?? false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(label: 'Save', isLoading: isSaving, onPressed: _save),
        ],
      ),
    );
  }
}
