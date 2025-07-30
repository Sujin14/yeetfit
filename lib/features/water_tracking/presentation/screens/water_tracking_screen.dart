import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../widgets/water_action_button.dart';
import '../widgets/water_app_bar.dart';
import '../widgets/water_chart_section.dart';
import '../widgets/water_circular_indicator.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/water_tip_card.dart';
import '../providers/water_provider.dart';

class WaterTrackingScreen extends ConsumerStatefulWidget {
  const WaterTrackingScreen({super.key});

  @override
  ConsumerState<WaterTrackingScreen> createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends ConsumerState<WaterTrackingScreen> {
  bool _hasNavigatedToSuccess = false;
  String? _lastNavigatedDate;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to track water intake')),
      );
    }

    ref.listen(glassesConsumedProvider(userId), (previous, next) {
      final glassesConsumed = next.value ?? 0;
      final goalGlasses = ref.read(waterGoalProvider(userId)).value ?? 8;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastDate = ref.read(glassesConsumedProvider(userId).notifier).lastDate;

      if (lastDate != null && lastDate != today) {
        _hasNavigatedToSuccess = false;
        _lastNavigatedDate = null;
      }

      if (glassesConsumed == goalGlasses && !_hasNavigatedToSuccess && _lastNavigatedDate != today) {
        _hasNavigatedToSuccess = true;
        _lastNavigatedDate = today;
        context.goNamed('water-success', pathParameters: {'goal': goalGlasses.toString()});
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.colors['lightBackground'],
      appBar: const WaterAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 150.h,
            child: Lottie.asset(
              'assets/animations/water.json',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16.h),
          Consumer(
            builder: (context, ref, _) {
              final glassesConsumed = ref.watch(
                glassesConsumedProvider(userId).select((value) => value.value ?? 0),
              );
              final goalGlasses = ref.watch(
                waterGoalProvider(userId).select((value) => value.value ?? 8),
              );
              return WaterProgressCard(
                glassesConsumed: glassesConsumed,
                goalGlasses: goalGlasses,
              );
            },
          ),
          SizedBox(height: 30.h),
          Consumer(
            builder: (context, ref, _) {
              final glassesConsumed = ref.watch(
                glassesConsumedProvider(userId).select((value) => value.value ?? 0),
              );
              final goalGlasses = ref.watch(
                waterGoalProvider(userId).select((value) => value.value ?? 8),
              );
              return WaterCircularIndicator(
                progress: goalGlasses > 0 ? glassesConsumed / goalGlasses : 0.0,
              );
            },
          ),
          SizedBox(height: 15.h),
          WaterActionButtons(
            onAdd: () => ref.read(glassesConsumedProvider(userId).notifier).addGlass(),
            onRemove: () => ref.read(glassesConsumedProvider(userId).notifier).removeGlass(),
          ),
          SizedBox(height: 30.h),
          const WaterTipCard(),
          SizedBox(height: 30.h),
          WaterChartSection(userId: userId),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}