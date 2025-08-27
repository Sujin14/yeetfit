import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/settings_provider.dart';
import '../widgets/activity_dropdown.dart';
import '../widgets/gender_dropdown.dart';
import '../widgets/info_field.dart';
import 'package:go_router/go_router.dart';

class BasicInformationBody extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController currentWeightController;
  final String? dailyActivity;
  final String? gender;
  final ValueChanged<String?> onActivityChanged;
  final ValueChanged<String?> onGenderChanged;

  const BasicInformationBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.currentWeightController,
    required this.dailyActivity,
    required this.gender,
    required this.onActivityChanged,
    required this.onGenderChanged,
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
              InfoField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: FixedSizes.box16(context)),
              GenderDropdown(value: gender, onChanged: onGenderChanged),
              SizedBox(height: FixedSizes.box16(context)),
              InfoField(
                controller: ageController,
                label: 'Age',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: FixedSizes.box16(context)),
              ActivityDropdown(
                value: dailyActivity,
                onChanged: onActivityChanged,
              ),
              SizedBox(height: FixedSizes.box16(context)),
              InfoField(
                controller: heightController,
                label: 'Height (cm)',
                icon: Icons.height,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: FixedSizes.box16(context)),
              InfoField(
                controller: currentWeightController,
                label: 'Current Weight (kg)',
                icon: Icons.scale,
                keyboardType: TextInputType.number,
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
                        minimumSize: Size(FixedSizes.buttonSize(context), FixedSizes.buttonSize(context)),
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
                                .saveBasicInformation(
                                  context: context,
                                  name: nameController.text,
                                  gender: gender ?? '',
                                  age: ageController.text,
                                  height: heightController.text,
                                  currentWeight: currentWeightController.text,
                                  activityLevel: dailyActivity ?? '',
                                  formKey: formKey,
                                ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['primaryButton'],
                        minimumSize: Size(
                          FixedSizes.buttonSize(context),
                          FixedSizes.buttonSize(context),
                        ),
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
