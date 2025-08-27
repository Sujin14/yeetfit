// time_duration_input.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import '../../../../utils/fixed_sizes.dart';

class TimeDurationInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const TimeDurationInput({super.key, required this.formKey});

  @override
  _TimeDurationInputState createState() => _TimeDurationInputState();
}

class _TimeDurationInputState extends ConsumerState<TimeDurationInput> {
  late TextEditingController _timeDurationController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    _timeDurationController = TextEditingController(
      text: userInfo.value?.timeDurationWeeks == null
          ? ''
          : userInfo.value?.timeDurationWeeks.toString(),
    );
  }

  @override
  void dispose() {
    _timeDurationController.dispose();
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
            "In how many weeks do you want to achieve your goal?",
            style: TextStyle(
              fontSize: FixedSizes.font16(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: FixedSizes.spacing(context) / 2),
          TextFormField(
            controller: _timeDurationController,
            decoration: InputDecoration(
              hintText: "Enter duration (weeks)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateTimeDuration,
            onSaved: (value) {
              final duration = int.tryParse(value ?? '') ?? 0;
              controller.setFormValue('timeDurationWeeks', duration);
            },
          ),
        ],
      ),
    );
  }
}
