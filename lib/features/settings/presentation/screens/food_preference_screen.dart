import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../widgets/food_preference_body.dart';

class FoodPreferencesScreen extends ConsumerStatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  ConsumerState<FoodPreferencesScreen> createState() =>
      _FoodPreferencesScreenState();
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Food Preferences',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: FoodPreferencesBody(
        formKey: _formKey,
        dietPreference: _dietPreference,
        allergies: _allergies,
        otherAllergy: _otherAllergy,
        cuisines: _cuisines,
        otherAllergyController: _otherAllergyController,
        onDietPreferenceChanged: (value) =>
            setState(() => _dietPreference = value),
        onAllergyChanged: (allergy, value) => setState(() {
          _allergies[allergy] = value ?? false;
          if (allergy == 'Others' && !value!) {
            _otherAllergy = '';
            _otherAllergyController.clear();
          }
        }),
        onOtherAllergyChanged: (value) => setState(() => _otherAllergy = value),
        onCuisineChanged: (cuisine, value) =>
            setState(() => _cuisines[cuisine] = value ?? false),
      ),
    );
  }
}
