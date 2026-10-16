import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../domain/entities/new_training_session.dart';
import '../utils/meet_link_validator.dart';
import 'session_date_time_field.dart';
import 'session_duration_selector.dart';
import 'session_field_label.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CreateSessionForm extends StatefulWidget {
  final bool isSubmitting;
  final ValueChanged<NewTrainingSession> onSubmit;

  const CreateSessionForm({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<CreateSessionForm> createState() => _CreateSessionFormState();
}

class _CreateSessionFormState extends State<CreateSessionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();
  DateTime? _scheduledAt;
  int _durationMinutes = 45;
  String? _scheduleError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initial = _scheduledAt ?? now.add(const Duration(hours: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _scheduleError = null;
    });
  }

  String? _validateSchedule() {
    final scheduledAt = _scheduledAt;
    if (scheduledAt == null) return 'Pick when the session starts';
    if (!scheduledAt.isAfter(DateTime.now())) {
      return 'The start time must be in the future';
    }
    return null;
  }

  void _submit() {
    final fieldsValid = _formKey.currentState?.validate() ?? false;
    final scheduleError = _validateSchedule();
    setState(() => _scheduleError = scheduleError);
    if (!fieldsValid || scheduleError != null) return;

    FocusScope.of(context).unfocus();
    widget.onSubmit(
      NewTrainingSession(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        meetLink: _linkController.text.trim(),
        scheduledAt: _scheduledAt!,
        durationMinutes: _durationMinutes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SessionFieldLabel('Title'),
            YeetTextField(
              controller: _titleController,
              hintText: 'e.g. Full-body HIIT',
              prefixIcon: Icons.title,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (value) => (value?.trim().isEmpty ?? true)
                  ? 'Give the session a title'
                  : null,
            ),
            const SessionFieldLabel('Description'),
            YeetTextField(
              controller: _descriptionController,
              hintText: 'What will you cover? Any equipment needed?',
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
            ),
            const SessionFieldLabel('Google Meet link'),
            YeetTextField(
              controller: _linkController,
              hintText: 'https://meet.google.com/abc-defg-hij',
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              validator: validateMeetLink,
            ),
            const SessionFieldLabel('Starts'),
            SessionDateTimeField(
              value: _scheduledAt,
              errorText: _scheduleError,
              onTap: _pickDateTime,
            ),
            const SessionFieldLabel('Duration'),
            SessionDurationSelector(
              selected: _durationMinutes,
              onSelected: (minutes) =>
                  setState(() => _durationMinutes = minutes),
            ),
            const SizedBox(height: AppSpacing.xl),
            GradientButton(
              label: 'Schedule Session',
              isLoading: widget.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
