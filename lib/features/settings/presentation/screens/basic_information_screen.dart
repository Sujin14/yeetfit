import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../user_info/presentation/providers/user_info_provider.dart';
import '../widgets/basic_information_body.dart';

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
    _dailyActivity = userInfo?.activityLevel.isNotEmpty ?? false ? userInfo!.activityLevel : null;
    _gender = userInfo?.gender.isNotEmpty ?? false ? userInfo!.gender : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Basic Information',
        showSettings: false,
        onSettings: null,
        showFavorite: false,
      ),
      body: BasicInformationBody(
        formKey: _formKey,
        nameController: _nameController,
        ageController: _ageController,
        heightController: _heightController,
        currentWeightController: _currentWeightController,
        dailyActivity: _dailyActivity,
        gender: _gender,
        onActivityChanged: (value) => setState(() => _dailyActivity = value),
        onGenderChanged: (value) => setState(() => _gender = value),
      ),
    );
  }
}