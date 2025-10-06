import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/theme/theme.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';
import '../providers/dashboard_provider.dart';
import 'progress_card.dart';

class ProgressCardsList extends ConsumerStatefulWidget {
  final String userId;

  const ProgressCardsList({super.key, required this.userId});

  @override
  _ProgressCardsListState createState() => _ProgressCardsListState();
}

class _ProgressCardsListState extends ConsumerState<ProgressCardsList> {
  final PageController _pageController = PageController();
  Timer? _autoSwipeTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (kDebugMode)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoSwipe();
      });
  }

  void _startAutoSwipe() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      setState(() {
        _currentPage =
            (_currentPage + 1) % 4; // 4 cards: steps, water, sleep, weight
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _startAutoSwipe();
  }

  @override
  void dispose() {
    if (kDebugMode) _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Helper to compute weight progress dynamically
  double _computeWeightPercent(double currentWeight, double goalWeight) {
    if (currentWeight == goalWeight) return 1.0;
    // Weight loss goal
    if (goalWeight < currentWeight) {
      final start = currentWeight; // starting weight
      final end = goalWeight; // target weight
      return ((start - currentWeight) / (start - end)).clamp(0.0, 1.0);
    } else {
      // Weight gain goal
      final start = currentWeight;
      final end = goalWeight;
      return ((currentWeight - start) / (end - start)).clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(dailyProgressStreamProvider(widget.userId));
    final stepsAsync = ref.watch(stepsCountProvider(widget.userId));

    return progressAsync.when(
      data: (progress) {
        // Combine Firestore data with real-time step count
        final steps = stepsAsync.when(
          data: (steps) => steps.toDouble(),
          loading: () => progress['steps'] as double,
          error: (_, __) => progress['steps'] as double,
        );

        final stepsGoal = progress['stepsGoal'] as double;

        final cards = [
          ProgressCard(
            title: 'Steps',
            percent: stepsGoal > 0 ? (steps / stepsGoal).clamp(0.0, 1.0) : 0.0,
            value: '${steps.toInt()}/${stepsGoal.toInt()} steps',
            icon: Icons.directions_walk,
            description: progress['stepsDescription'],
            route: '/modal/steps',
            userId: widget.userId,
          ),
          ProgressCard(
            title: 'Water',
            percent: (progress['water'] / progress['waterGoal']).clamp(
              0.0,
              1.0,
            ),
            value:
                '${progress['water'].toInt()}/${progress['waterGoal'].toInt()} glasses',
            icon: Icons.water_drop,
            description: progress['waterDescription'],
            route: '/modal/water',
            userId: widget.userId,
          ),
          ProgressCard(
            title: 'Sleep',
            percent: (progress['sleep'] / progress['sleepGoal']).clamp(
              0.0,
              1.0,
            ),
            value:
                '${progress['sleep'].toStringAsFixed(1)}/${progress['sleepGoal'].toStringAsFixed(1)} h',
            icon: Icons.bedtime,
            description: progress['sleepDescription'],
            route: '/modal/sleep',
            userId: widget.userId,
          ),
          ProgressCard(
            title: 'Weight',
            percent: _computeWeightPercent(
              progress['currentWeight'],
              progress['weightGoal'],
            ),
            value:
                '${progress['currentWeight'].toStringAsFixed(1)}/${progress['weightGoal'].toStringAsFixed(1)} kg',
            icon: Icons.scale,
            description: progress['weightDescription'],
            route: '/modal/weight',
            userId: widget.userId,
          ),
        ];

        return Column(
          children: [
            SizedBox(
              height: 200.h,
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: cards,
              ),
            ),
            SizedBox(height: 8.h),
            SmoothPageIndicator(
              controller: _pageController,
              count: cards.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8.w,
                dotHeight: 8.h,
                activeDotColor: AppTheme.colors['primaryAccent']!,
                dotColor: AppTheme.colors['secondaryText']!.withOpacity(0.5),
                spacing: 4.w,
              ),
            ),
          ],
        );
      },
      loading: () => Column(
        children: [
          ProgressCard.loading(userId: widget.userId),
          SizedBox(height: 8.h),
          SmoothPageIndicator(
            controller: _pageController,
            count: 4,
            effect: ExpandingDotsEffect(
              dotWidth: 8.w,
              dotHeight: 8.h,
              activeDotColor: AppTheme.colors['primaryAccent']!,
              dotColor: AppTheme.colors['secondaryText']!.withOpacity(0.5),
              spacing: 4.w,
            ),
          ),
        ],
      ),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
