import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/drag_handle.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../../domain/entities/workout_log.dart';
import '../providers/workout_log_form_provider.dart';
import 'workout_form_label.dart';
import 'workout_intensity_selector.dart';
import 'workout_plan_banner.dart';
import 'workout_type_selector.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Logs (or edits) today's workout, pre-filled from today's log or the
/// coach's plan for today.
class LogWorkoutSheet extends ConsumerStatefulWidget {
  final String userId;

  const LogWorkoutSheet({super.key, required this.userId});

  static Future<void> show(BuildContext context, {required String userId}) {
    return showModalBottomSheet<void>(
      context: context,
      // The tab navigators sit under the floating nav bar, which would cover
      // the sheet's Save button.
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => LogWorkoutSheet(userId: userId),
    );
  }

  @override
  ConsumerState<LogWorkoutSheet> createState() => _LogWorkoutSheetState();
}

class _LogWorkoutSheetState extends ConsumerState<LogWorkoutSheet> {
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final duration = ref
        .read(workoutLogFormProvider(widget.userId))
        .durationMinutes;
    _durationController = TextEditingController(text: duration?.toString());
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = workoutLogFormProvider(widget.userId);
    // Re-checked here so a second tap in the same frame can't pop twice.
    if (ref.read(form).isSubmitting) return;
    final error = await ref.read(form.notifier).submit();
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final provider = workoutLogFormProvider(widget.userId);
    final form = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    // Pre-fill can arrive after the sheet opens; typing never re-enters here
    // with a different value, so the cursor isn't disturbed.
    ref.listen(provider.select((form) => form.durationMinutes), (_, minutes) {
      if (int.tryParse(_durationController.text) == minutes) return;
      _durationController.text = minutes?.toString() ?? '';
    });

    final planTitle = form.planTitle;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.smd,
        AppSpacing.screenEdge,
        MediaQuery.viewInsetsOf(context).bottom +
            MediaQuery.paddingOf(context).bottom +
            20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DragHandle(),
            Text(
              "Log Today's Workout",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: colors.onBackground),
            ),
            if (planTitle != null) ...[
              const SizedBox(height: AppSpacing.smd),
              WorkoutPlanBanner(planTitle: planTitle),
            ],
            const SizedBox(height: 20),
            const WorkoutFormLabel('Workout type'),
            WorkoutTypeSelector(
              selected: form.type,
              onSelected: notifier.setType,
            ),
            const SizedBox(height: 20),
            const WorkoutFormLabel(
              'Duration (${WorkoutLog.minDurationMinutes}–'
              '${WorkoutLog.maxDurationMinutes} min)',
            ),
            YeetTextField(
              controller: _durationController,
              hintText: 'Minutes',
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              textInputAction: TextInputAction.done,
              onChanged: notifier.setDuration,
            ),
            const SizedBox(height: 20),
            const WorkoutFormLabel('Intensity'),
            WorkoutIntensitySelector(
              selected: form.intensity,
              onSelected: notifier.setIntensity,
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              label: 'Save Workout',
              isLoading: form.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
