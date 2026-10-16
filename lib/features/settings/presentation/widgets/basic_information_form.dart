import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../../user_info/data/models/user_info_model.dart';
import '../../../user_info/domain/validators/user_info_validators.dart';
import '../../../user_info/presentation/utils/profile_options.dart';
import '../providers/settings_provider.dart';
import 'settings_chip_group.dart';
import 'settings_field_label.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class BasicInformationForm extends ConsumerStatefulWidget {
  final UserInfoModel? userInfo;

  const BasicInformationForm({super.key, required this.userInfo});

  @override
  ConsumerState<BasicInformationForm> createState() =>
      _BasicInformationFormState();
}

class _BasicInformationFormState extends ConsumerState<BasicInformationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final String _initialWeightText;
  String? _gender;
  String? _activityLevel;

  static String _numberText(num? value) =>
      value == null || value == 0 ? '' : value.toString();

  @override
  void initState() {
    super.initState();
    final userInfo = widget.userInfo;
    _nameController = TextEditingController(text: userInfo?.name ?? '');
    _ageController = TextEditingController(text: _numberText(userInfo?.age));
    _heightController = TextEditingController(
      text: _numberText(userInfo?.height),
    );
    _initialWeightText = _numberText(userInfo?.currentWeight);
    _weightController = TextEditingController(text: _initialWeightText);
    _gender = (userInfo?.gender.isNotEmpty ?? false) ? userInfo!.gender : null;
    _activityLevel = (userInfo?.activityLevel.isNotEmpty ?? false)
        ? userInfo!.activityLevel
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final weightText = _weightController.text.trim();
    ref
        .read(settingsControllerProvider.notifier)
        .saveBasicInformation(
          name: _nameController.text,
          gender: _gender ?? '',
          age: _ageController.text.trim(),
          height: _heightController.text.trim(),
          // The prefilled weight comes from the cached profile, so it's only
          // sent when the user changed it.
          editedWeight: weightText == _initialWeightText.trim()
              ? null
              : weightText,
          activityLevel: _activityLevel ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(settingsControllerProvider).isLoading;
    const numberKeyboard = TextInputType.numberWithOptions(decimal: true);

    return Form(
      key: _formKey,
      child: Padding(
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
                  const SettingsFieldLabel('Name'),
                  YeetTextField(
                    controller: _nameController,
                    hintText: 'Your name',
                    prefixIcon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: UserInfoValidators.validateName,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const SettingsFieldLabel('Age'),
                  YeetTextField(
                    controller: _ageController,
                    hintText: 'Years',
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: UserInfoValidators.validateAge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const SettingsFieldLabel('Height (cm)'),
                  YeetTextField(
                    controller: _heightController,
                    hintText: 'cm',
                    prefixIcon: Icons.height,
                    keyboardType: numberKeyboard,
                    textInputAction: TextInputAction.next,
                    validator: UserInfoValidators.validateHeight,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const SettingsFieldLabel('Current weight (kg)'),
                  YeetTextField(
                    controller: _weightController,
                    hintText: 'kg',
                    prefixIcon: Icons.monitor_weight_outlined,
                    keyboardType: numberKeyboard,
                    textInputAction: TextInputAction.done,
                    validator: UserInfoValidators.validateWeight,
                  ),
                  const SizedBox(height: 20),
                  SettingsChipGroup(
                    label: 'Gender',
                    options: genderOptions,
                    isSelected: (option) => _gender == option,
                    onTap: (option) => setState(() => _gender = option),
                  ),
                  const SizedBox(height: 20),
                  SettingsChipGroup(
                    label: 'Daily activity level',
                    options: [
                      for (final option in activityLevelOptions) option.value,
                    ],
                    labelFor: (value) => activityLevelOptions
                        .firstWhere((option) => option.value == value)
                        .label,
                    isSelected: (option) => _activityLevel == option,
                    onTap: (option) => setState(() => _activityLevel = option),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              label: 'Save',
              isLoading: isSaving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
