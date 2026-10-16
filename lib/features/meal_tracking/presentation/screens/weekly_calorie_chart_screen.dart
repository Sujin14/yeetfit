import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/shared/providers/auth_providers.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import 'package:yeetfit/shared/widgets/shell_gradient_background.dart';
import 'package:yeetfit/shared/widgets/sign_in_required_view.dart';
import '../widgets/calorie_chart_card.dart';

class WeeklyCalorieChartScreen extends ConsumerWidget {
  const WeeklyCalorieChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authUserIdProvider);
    return ShellGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: userId == null
            ? const SignInRequiredView(
                message: 'Please log in to see your week',
              )
            : CustomScrollView(
                slivers: [
                  const GlassSliverAppBar(title: 'Weekly Nutrition'),
                  SliverToBoxAdapter(child: CalorieChartCard(userId: userId)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }
}
