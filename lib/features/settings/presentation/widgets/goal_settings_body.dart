import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/settings_provider.dart';
import '../widgets/goal_card.dart';

class GoalSettingsBody extends ConsumerWidget {
  final Map<String, String> goals;
  final Map<String, Color> goalColors;

  const GoalSettingsBody({
    super.key,
    required this.goals,
    required this.goalColors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final isSaving = ref.watch(settingsControllerProvider.notifier).isSaving;

    return settingsState.when(
      data: (_) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: FixedSizes.box24(context),
          vertical: FixedSizes.box24(context),
        ),
        child: Column(
          children: [
            ...goals.keys.map(
              (goal) => Padding(
                padding: EdgeInsets.only(bottom: FixedSizes.box16(context)),
                child: GoalCard(
                  title: goal,
                  selectedGoal: goals[goal]!,
                  unit: goal == "Weight"
                      ? "kg"
                      : goal == "Steps"
                          ? "steps"
                          : "",
                  color: goalColors[goal] ?? AppTheme.colors['primaryButton']!,
                  onGoalSelected: isSaving
                      ? null
                      : (newGoal) {
                          // handle goal selection here
                        },
                ),
              ),
            ),
            SizedBox(height: FixedSizes.box24(context)),
            ElevatedButton(
              onPressed: isSaving ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors['primaryButton'],
                minimumSize: Size(
                  FixedSizes.buttonWidthStandard(context),
                  FixedSizes.buttonHeightStandard(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    FixedSizes.radius8(context),
                  ),
                ),
              ),
              child: isSaving
                  ? SizedBox(
                      width: FixedSizes.box24(context),
                      height: FixedSizes.box24(context),
                      child: CircularProgressIndicator(
                        color: AppTheme.colors['onSurfaceDark'],
                      ),
                    )
                  : Text(
                      'Save Goals',
                      style: AppTheme.textStyles['body']!.copyWith(
                        color: AppTheme.colors['onSurfaceDark'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']!.copyWith(
            color: AppTheme.colors['primaryText'],
          ),
        ),
      ),
    );
  }
}
