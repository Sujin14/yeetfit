import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../widgets/water_action_button.dart';
import '../widgets/water_app_bar.dart';
import '../widgets/water_chart_section.dart';
import '../widgets/water_circular_indicator.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_tip_card.dart';
import '../providers/water_provider.dart';

class WaterTrackingScreen extends ConsumerWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track water intake')),
      );
    }

    ref.listen(waterTrackingNavigationProvider(userId), (previous, hasNavigated) {
      if (hasNavigated) {
        final goalGlasses = ref.read(waterGoalProvider(userId)).value ?? 8;
        context.goNamed(
          'water-success',
          pathParameters: {'goal': goalGlasses.toString()},
        );
      }
    });

    final consumed = ref.watch(glassesConsumedProvider(userId)).value ?? 0;
    final goal = ref.watch(waterGoalProvider(userId)).value ?? 8;
    final progress = goal > 0 ? consumed / goal : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      appBar: const WaterAppBar(),
      body: ListView(
        padding: EdgeInsets.all(FixedSizes.box16(context)),
        children: [
          SizedBox(
            height: FixedSizes.box150(context),
            child: Lottie.asset(
              'assets/animations/water.json',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: FixedSizes.box16(context)),
          const WaterProgressCard(),
          SizedBox(height: FixedSizes.box30(context)),
          WaterCircularIndicator(progress: progress),
          SizedBox(height: FixedSizes.box14(context)),
          WaterActionButtons(
            onAdd: () => ref.read(glassesConsumedProvider(userId).notifier).addGlass(),
            onRemove: () => ref.read(glassesConsumedProvider(userId).notifier).removeGlass(),
          ),
          SizedBox(height: FixedSizes.box30(context)),
          const WaterTipCard(),
          SizedBox(height: FixedSizes.box30(context)),
          WaterChartSection(userId: userId),
          SizedBox(height: FixedSizes.box50(context)),
        ],
      ),
    );
  }
}
