import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/profile/pick_and_crop_profile_image.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';
import 'gender_selector_field.dart';
import 'profile_photo_picker.dart';
import 'step_content_card.dart';
import 'step_question.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class NameGenderInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onGenderChanged;

  const NameGenderInput({
    super.key,
    required this.formKey,
    required this.onGenderChanged,
  });

  @override
  ConsumerState<NameGenderInput> createState() => _NameGenderInputState();
}

class _NameGenderInputState extends ConsumerState<NameGenderInput> {
  bool _isUploading = false;
  late final TextEditingController _nameController;
  String? _initialGender;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    final savedGender = userInfo.value?.gender ?? '';
    _initialGender = savedGender.isNotEmpty ? savedGender : null;
    final savedName = userInfo.value?.name ?? '';
    final pendingName = ref
        .read(userInfoControllerProvider.notifier)
        .formValue('name');
    _nameController = TextEditingController(
      text: savedName.isNotEmpty
          ? savedName
          : (pendingName is String ? pendingName : ''),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isUploading) return;
    setState(() => _isUploading = true);
    await pickAndCropProfileImage(context);
    if (mounted) setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = ref.watch(
      userInfoControllerProvider.select(
        (state) => state.value?.profileImageUrl,
      ),
    );
    final controller = ref.read(userInfoControllerProvider.notifier);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          ProfilePhotoPicker(
            networkImageUrl: profileImageUrl,
            isUploading: _isUploading,
            onTap: _pickImage,
          ),
          const SizedBox(height: AppSpacing.lg),
          const StepQuestion("What's your name?"),
          StepContentCard(
            child: YeetTextField(
              controller: _nameController,
              hintText: 'Enter your name',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.name],
              validator: UserInfoValidators.validateName,
              onSaved: (value) {
                if (value != null) {
                  controller.setFormValue('name', value.trim());
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const StepQuestion("What's your gender?"),
          StepContentCard(
            child: GenderSelectorField(
              initialValue: _initialGender,
              onChanged: widget.onGenderChanged,
              onSaved: (value) {
                if (value != null) controller.setFormValue('gender', value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
