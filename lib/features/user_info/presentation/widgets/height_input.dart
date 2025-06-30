import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_controller.dart';
import '../../domain/validators/user_info_validators.dart';

class HeightInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const HeightInput({super.key, required this.formKey});

  @override
  _HeightInputState createState() => _HeightInputState();
}

class _HeightInputState extends ConsumerState<HeightInput> {
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _heightController = TextEditingController(
      text: userInfo.height == 0 ? '' : userInfo.height.toString(),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What is your height?"),
          const SizedBox(height: 8),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(hintText: "Enter height (cm)"),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateHeight,
            onChanged: (val) {
              final height = double.tryParse(val) ?? 0;
              notifier.updateHeight(height, context);
            },
          ),
        ],
      ),
    );
  }
}
