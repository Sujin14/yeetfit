import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/calorie_tracking_screen_body.dart';
import '../widgets/calorie_appbar.dart';

class CalorieTrackingScreen extends ConsumerWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: CalorieAppBar(),
      body: CalorieTrackingScreenBody(),
    );
  }
}