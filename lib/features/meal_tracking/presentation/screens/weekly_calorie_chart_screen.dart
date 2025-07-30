import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../widgets/calorie_chart_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeklyCalorieChartScreen extends ConsumerWidget {
  const WeeklyCalorieChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors['transparent'],
        elevation: 0,
        title: Text(
          'Weekly Calorie Intake',
          style: TextStyle(color: AppTheme.colors['onSurface']),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors['onSurface']),
          onPressed: () => context.go('/modal/food'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CalorieChartCard(userId: userId),
      ),
    );
  }
}