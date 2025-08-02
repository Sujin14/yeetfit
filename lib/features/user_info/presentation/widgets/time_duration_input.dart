import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_info_controller.dart';
import '../../domain/validators/user_info_validators.dart';

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
      text: userInfo.timeDurationWeeks == null ? '' : userInfo.timeDurationWeeks.toString(),
    );
  }

  @override
  void dispose() {
    _timeDurationController.dispose();
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
          const Text("In how many weeks do you want to achieve your goal?"),
          const SizedBox(height: 8),
          TextFormField(
            controller: _timeDurationController,
            decoration: const InputDecoration(
              hintText: "Enter duration (weeks)",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: UserInfoValidators.validateTimeDuration,
            onChanged: (val) {
              final duration = int.tryParse(val) ?? 0;
              notifier.updateTimeDuration(duration, context);
            },
          ),
        ],
      ),
    );
  }
}