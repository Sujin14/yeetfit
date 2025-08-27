// age_input.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../../../../utils/fixed_sizes.dart';

class AgeInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const AgeInput({
    super.key,
    required this.formKey,
  });

  @override
  _AgeInputState createState() => _AgeInputState();
}

class _AgeInputState extends ConsumerState<AgeInput> {
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _ageController = TextEditingController(
      text: userInfo.value?.age == 0 ? '' : userInfo.value!.age.toString(),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
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
            "What is your age?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              hintText: "Enter your age",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateAge,
            onSaved: (value) {
              final age = int.tryParse(value ?? '') ?? 0;
              controller.setFormValue('age', age);
            },
          ),
        ],
      ),
    );
  }
}
