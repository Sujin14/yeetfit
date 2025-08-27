import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';

class HeightInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const HeightInput({
    super.key,
    required this.formKey,
  });

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
      text: userInfo.value?.height == 0 ? '' : userInfo.value!.height.toString(),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
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
            "What is your height?",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
              hintText: "Enter height (cm)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateHeight,
            onSaved: (value) {
              final height = double.tryParse(value ?? '') ?? 0;
              controller.setFormValue('height', height);
            },
          ),
        ],
      ),
    );
  }
}