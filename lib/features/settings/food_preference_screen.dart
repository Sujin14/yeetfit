import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../user_info/presentation/providers/user_info_controller.dart';

class FoodPreferencesScreen extends ConsumerStatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  ConsumerState<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends ConsumerState<FoodPreferencesScreen> {
  String? _dietPreference;
  final Map<String, bool> _allergies = {
    'Dairy': false,
    'Seafood': false,
    'Nuts': false,
    'Lamb/Mutton': false,
    'Others': false,
  };
  String? _otherAllergy;
  final Map<String, bool> _cuisines = {
    'North Indian': false,
    'South Indian': false,
    'Continental': false,
    'Chinese': false,
  };
  final _otherAllergyController = TextEditingController();

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userInfoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Preferences',
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
          _dietPreference = userInfo.dietPreference ?? 'Vegetarian';
          _allergies.addAll(userInfo.allergies ?? {
            'Dairy': false,
            'Seafood': false,
            'Nuts': false,
            'Lamb/Mutton': false,
            'Others': false,
          });
          _otherAllergy = userInfo.otherAllergy ?? '';
          _otherAllergyController.text = _otherAllergy ?? '';
          _cuisines.addAll(userInfo.cuisines ?? {
            'North Indian': false,
            'South Indian': false,
            'Continental': false,
            'Chinese': false,
          });

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/diet_image.png',
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
                DropdownButtonFormField<String>(
                  value: _dietPreference,
                  decoration: InputDecoration(
                    labelText: 'Diet Preference',
                    labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  items: ['Vegetarian', 'Non-Vegetarian', 'Vegan']
                      .map((diet) => DropdownMenuItem(value: diet, child: Text(diet)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _dietPreference = value;
                    });
                    ref.read(userInfoControllerProvider.notifier).updateDietPreference(value, context);
                  },
                  style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Any Allergies?',
                  style: AppTheme.textStyles['subtitle']!.copyWith(
                    fontSize: 18.sp,
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
                ..._allergies.keys.map((allergy) => CheckboxListTile(
                      title: Text(
                        allergy,
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                      value: _allergies[allergy],
                      onChanged: (value) {
                        setState(() {
                          _allergies[allergy] = value ?? false;
                          if (allergy == 'Others' && !value!) {
                            _otherAllergy = '';
                            _otherAllergyController.clear();
                          }
                        });
                        ref.read(userInfoControllerProvider.notifier).updateAllergies(_allergies, context);
                      },
                    )),
                if (_allergies['Others']!)
                  TextField(
                    controller: _otherAllergyController,
                    decoration: InputDecoration(
                      labelText: 'Specify Other Allergy',
                      labelStyle: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['secondaryText']),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                    onChanged: (value) {
                      _otherAllergy = value;
                      ref.read(userInfoControllerProvider.notifier).updateOtherAllergy(value, context);
                    },
                  ),
                SizedBox(height: 16.h),
                Divider(color: AppTheme.colors['borderGradientStart']),
                SizedBox(height: 16.h),
                Text(
                  'What is your Preferred Cuisine?',
                  style: AppTheme.textStyles['subtitle']!.copyWith(
                    fontSize: 18.sp,
                    color: AppTheme.colors['primaryText'],
                  ),
                ),
                ..._cuisines.keys.map((cuisine) => CheckboxListTile(
                      title: Text(
                        cuisine,
                        style: AppTheme.textStyles['body']!.copyWith(color: AppTheme.colors['primaryText']),
                      ),
                      value: _cuisines[cuisine],
                      onChanged: (value) {
                        setState(() {
                          _cuisines[cuisine] = value ?? false;
                        });
                        ref.read(userInfoControllerProvider.notifier).updateCuisines(_cuisines, context);
                      },
                    )),
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