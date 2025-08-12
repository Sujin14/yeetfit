import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../user_info/presentation/providers/user_info_controller.dart';
import '../providers/settings_provider.dart';

class FoodPreferencesScreen extends ConsumerStatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  ConsumerState<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends ConsumerState<FoodPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
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
  late TextEditingController _otherAllergyController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider).value;
    _dietPreference = userInfo?.dietPreference ?? 'Vegetarian';
    _allergies.addAll(userInfo?.allergies ?? _allergies);
    _otherAllergy = userInfo?.otherAllergy ?? '';
    _otherAllergyController = TextEditingController(text: _otherAllergy);
    _cuisines.addAll(userInfo?.cuisines ?? _cuisines);
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Preferences',
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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                DropdownButtonFormField<String>(
                  value: _dietPreference,
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
                  onChanged: (value) => setState(() => _dietPreference = value),
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
                ..._allergies.keys.map(
                  (allergy) => CheckboxListTile(
                    title: Text(
                      allergy,
                      style: AppTheme.textStyles['body']!.copyWith(
                        color: AppTheme.colors['primaryText'],
                      ),
                    ),
                    value: _allergies[allergy],
                    onChanged: (value) => setState(() {
                      _allergies[allergy] = value ?? false;
                      if (allergy == 'Others' && !value!) {
                        _otherAllergy = '';
                        _otherAllergyController.clear();
                      }
                    }),
                  ),
                ),
                if (_allergies['Others']!)
                  TextFormField(
                    controller: _otherAllergyController,
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
                    onChanged: (value) => setState(() => _otherAllergy = value),
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
                ..._cuisines.keys.map(
                  (cuisine) => CheckboxListTile(
                    title: Text(
                      cuisine,
                      style: AppTheme.textStyles['body']!.copyWith(
                        color: AppTheme.colors['primaryText'],
                      ),
                    ),
                    value: _cuisines[cuisine],
                    onChanged: (value) => setState(() => _cuisines[cuisine] = value ?? false),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isSaving ? null : () => context.pop(),
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
                      onPressed: isSaving
                          ? null
                          : () async {
                              final success = await ref
                                  .read(settingsControllerProvider.notifier)
                                  .saveFoodPreferences(
                                    context: context,
                                    dietPreference: _dietPreference,
                                    allergies: _allergies,
                                    otherAllergy: _otherAllergy,
                                    cuisines: _cuisines,
                                    formKey: _formKey,
                                  );
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Food preferences saved successfully',
                                      style: AppTheme.textStyles['body']!.copyWith(
                                        color: AppTheme.colors['onSurfaceDark'],
                                      ),
                                    ),
                                    backgroundColor: AppTheme.colors['primaryButton'] ?? Colors.green,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 48.h),
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