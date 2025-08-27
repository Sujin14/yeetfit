// weight_input.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const WeightInput({
    super.key,
    required this.formKey,
  });

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends ConsumerState<WeightInput> {
  late TextEditingController _currentWeightController;
  late TextEditingController _goalWeightController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _currentWeightController = TextEditingController(
      text: userInfo.value?.currentWeight == 0
          ? ''
          : userInfo.value?.currentWeight.toString(),
    );
    _goalWeightController = TextEditingController(
      text: userInfo.value?.goalWeight == 0
          ? ''
          : userInfo.value?.goalWeight.toString(),
    );
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is your current weight?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          TextFormField(
            controller: _currentWeightController,
            decoration: InputDecoration(
              hintText: "Enter current weight (kg)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateWeight,
            onSaved: (value) {
              final weight = double.tryParse(value ?? '') ?? 0;
              controller.setFormValue('currentWeight', weight);
            },
          ),
          SizedBox(height: FixedSizes.spacing(context) * 1.5),
          Text(
            "What is your goal weight?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          TextFormField(
            controller: _goalWeightController,
            decoration: InputDecoration(
              hintText: "Enter goal weight (kg)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateWeight,
            onSaved: (value) {
              final weight = double.tryParse(value ?? '') ?? 0;
              controller.setFormValue('goalWeight', weight);
            },
          ),
        ],
      ),
    );
  }
}
