import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../providers/steps_provider.dart';
import '../widgets/steps_action_button.dart';
import '../widgets/steps_animation.dart';
import '../widgets/steps_app_bar.dart';
import '../widgets/steps_action_sheet.dart';
import '../widgets/steps_calorie_card_container.dart';
import '../widgets/steps_chart_card.dart';
import '../widgets/steps_progress_card_container.dart';
import '../widgets/steps_tip_card.dart';
import '../widgets/steps_tracking_toggle.dart';

class StepCounterScreen extends ConsumerStatefulWidget {
  const StepCounterScreen({super.key});

  @override
  ConsumerState<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends ConsumerState<StepCounterScreen> {
  bool _usePedometer = true;
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to track steps',
            style: TextStyle(color: AppTheme.colors['primaryText']),
          ),
        ),
      );
    }

    final today = DateTime.now().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: const StepsAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen(stepsCountProvider(userId), (previous, next) {
            next.whenData((steps) {
              final goalAsync = ref.watch(stepsGoalProvider(userId));
              goalAsync.whenData((goalSteps) {
                if (steps >= goalSteps && !_hasNavigated) {
                  if (kDebugMode) print('Goal reached, navigating...');
                  _hasNavigated = true;
                  context.push('/steps-success/$goalSteps').then((_) {
                    if (mounted) setState(() => _hasNavigated = false);
                  });
                }
              });
            });
          });

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(stepsCountProvider(userId)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const StepsAnimation(),
                  StepsTrackingModeToggle(
                    isPedometerActive: _usePedometer,
                    onToggle: (value) {
                      setState(() {
                        _usePedometer = value;
                        ref
                            .read(stepsCountProvider(userId).notifier)
                            .togglePedometer(value);
                        if (value) ref.invalidate(stepsCountProvider(userId));
                      });
                    },
                  ),
                  SizedBox(height: FixedSizes.box16(context)),
                  StepsProgressCardContainer(userId: userId, today: today),
                  SizedBox(height: FixedSizes.box18(context)),
                  StepsCaloriesCardContainer(userId: userId),
                  SizedBox(height: FixedSizes.box18(context)),
                  const StepsTipCard(),
                  SizedBox(height: FixedSizes.box18(context)),
                  StepsChartSection(barGroups: []),
                  SizedBox(height: FixedSizes.box60(context)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: StepsActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: AppTheme.colors['transparent'],
          builder: (context) =>
              StepsActionSheet(onSetGoal: () {}, onReset: () {}),
        ),
      ),
    );
  }
}

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
