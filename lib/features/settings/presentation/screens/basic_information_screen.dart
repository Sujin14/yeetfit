import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';

class BasicInformationScreen extends ConsumerStatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  ConsumerState<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends ConsumerState<BasicInformationScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  String? _dailyActivity;
  String? _gender;

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
    final userDataAsync = ref.watch(userInfoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: AppTheme.textStyles['title']!.copyWith(color: AppTheme.colors['primaryText']),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userDataAsync.when(
        data: (userInfo) {
          _nameController.text = userInfo.name;
          _ageController.text = userInfo.age.toString();
          _heightController.text = userInfo.height.toString();
          _currentWeightController.text = userInfo.currentWeight.toString();
          _targetWeightController.text = userInfo.goalWeight.toString();
          _dailyActivity = userInfo.activityLevel.isNotEmpty ? userInfo.activityLevel : 'Moderate';
          _gender = userInfo.gender.isNotEmpty ? userInfo.gender : 'Male';

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: AppTheme.colors['primaryText']),
                  title: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.transgender, color: AppTheme.colors['primaryText']),
                  title: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                      ref.read(userInfoControllerProvider.notifier).updateGender(value ?? 'Male', context);
                    },
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.cake, color: AppTheme.colors['primaryText']),
                  title: TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.directions_run, color: AppTheme.colors['primaryText']),
                  title: DropdownButtonFormField<String>(
                    value: _dailyActivity,
                    decoration: InputDecoration(
                      labelText: 'Daily Activity',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    items: ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active']
                        .map((activity) => DropdownMenuItem(value: activity, child: Text(activity)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _dailyActivity = value;
                      });
                      ref.read(userInfoControllerProvider.notifier).updateActivityLevel(value ?? 'Moderate', context);
                    },
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.height, color: AppTheme.colors['primaryText']),
                  title: TextField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.scale, color: AppTheme.colors['primaryText']),
                  title: TextField(
                    controller: _currentWeightController,
                    decoration: InputDecoration(
                      labelText: 'Current Weight (kg)',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.fitness_center, color: AppTheme.colors['primaryText']),
                  title: TextField(
                    controller: _targetWeightController,
                    decoration: InputDecoration(
                      labelText: 'Target Weight (kg)',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors['error'],
                        minimumSize: Size(150.w, 48.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTheme.textStyles['body']!.copyWith(
                          color: AppTheme.colors['onSurfaceDark'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ref.read(userInfoControllerProvider.notifier).updateName(_nameController.text, context);
                        ref.read(userInfoControllerProvider.notifier).updateAge(
                              int.tryParse(_ageController.text) ?? 30,
                              context,
                            );
                        ref.read(userInfoControllerProvider.notifier).updateHeight(
                              double.tryParse(_heightController.text) ?? 181.0,
                              context,
                            );
                        ref.read(userInfoControllerProvider.notifier).updateWeights(
                              current: double.tryParse(_currentWeightController.text),
                              goal: double.tryParse(_targetWeightController.text),
                              context: context,
                            );
                        await ref.read(userInfoControllerProvider.notifier).saveUserData(context);
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 48.h),
                      ),
                      child: Text(
                        'Save',
                        style: AppTheme.textStyles['body']!.copyWith(
                          color: AppTheme.colors['onSurfaceDark'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
          ),
        ),
      ),
    );
  }
}