import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/goal_settings_body.dart';

class GoalSettingsScreen extends ConsumerWidget {
  const GoalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal Settings',
          style: AppTheme.textStyles['title']!.copyWith(
            color: AppTheme.colors['primaryText'],
            fontSize: FixedSizes.font18(context),
          ),
        ),
        backgroundColor: AppTheme.colors['lightBackground'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['primaryText']),
          onPressed: () => context.pop(),
        ),
      ),
      body: GoalSettingsBody(
        goals: {'Weight': '70', 'Steps': '1000', 'Calories': '2000'},
        goalColors: {
          'Weight': AppTheme.colors['primaryButton']!,
          'Steps': AppTheme.colors['secondaryButton']!,
          'Calories': AppTheme.colors['accent']!,
        },
      ),
    );
  }
}
