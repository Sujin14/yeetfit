import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../providers/settings_provider.dart';
import '../widgets/activity_dropdown.dart';
import '../widgets/gender_dropdown.dart';
import '../widgets/info_field.dart';

class BasicInformationScreen extends ConsumerStatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  ConsumerState<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends ConsumerState<BasicInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _currentWeightController;
  late TextEditingController _targetWeightController;
  String? _dailyActivity;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider).value;
    _nameController = TextEditingController(text: userInfo?.name ?? '');
    _ageController = TextEditingController(text: userInfo?.age.toString() ?? '');
    _heightController = TextEditingController(text: userInfo?.height.toString() ?? '');
    _currentWeightController = TextEditingController(text: userInfo?.currentWeight.toString() ?? '');
    _targetWeightController = TextEditingController(text: userInfo?.goalWeight.toString() ?? '');
    _dailyActivity = userInfo?.activityLevel.isNotEmpty ?? false ? userInfo!.activityLevel : null;
    _gender = userInfo?.gender.isNotEmpty ?? false ? userInfo!.gender : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: AppTheme.textStyles['title']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: settingsState.when(
        data: (_) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.h),
                GenderDropdown(
                  value: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                SizedBox(height: 16.h),
                InfoField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                ActivityDropdown(
                  value: _dailyActivity,
                  onChanged: (value) => setState(() => _dailyActivity = value),
                ),
                SizedBox(height: 16.h),
                InfoField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                InfoField(
                  controller: _currentWeightController,
                  label: 'Current Weight (kg)',
                  icon: Icons.scale,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                InfoField(
                  controller: _targetWeightController,
                  label: 'Target Weight (kg)',
                  icon: Icons.fitness_center,
                  keyboardType: TextInputType.number,
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
                            : () => ref.read(settingsControllerProvider.notifier).saveBasicInformation(
                                  context: context,
                                  name: _nameController.text,
                                  gender: _gender ?? '',
                                  age: _ageController.text,
                                  height: _heightController.text,
                                  currentWeight: _currentWeightController.text,
                                  goalWeight: _targetWeightController.text,
                                  activityLevel: _dailyActivity ?? '',
                                  formKey: _formKey,
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
      ),
    );
  }
}