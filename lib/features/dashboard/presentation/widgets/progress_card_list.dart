import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import 'progress_card.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';

class ProgressCardsList extends ConsumerStatefulWidget {
  final Map<String, dynamic> progress;
  final String userId;

  const ProgressCardsList({
    super.key,
    required this.progress,
    required this.userId,
  });

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSwipe();
    });
  }

  void _startAutoSwipe() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      setState(() {
        _currentPage = (_currentPage + 1) % 4;
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
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(stepsCountProvider(widget.userId));

    // Build cards using the progress passed from parent
    final progress = widget.progress;
    final stepsGoal = (progress['stepsGoal'] as num?)?.toDouble() ?? 10000.0;

    final steps = stepsAsync.when<double>(
      data: (s) => s.toDouble(),
      loading: () => (progress['steps'] as num?)?.toDouble() ?? 0.0,
      error: (_, __) => (progress['steps'] as num?)?.toDouble() ?? 0.0,
    );

    final cards = [
      ProgressCard(
        title: 'Steps',
        percent: stepsGoal > 0 ? (steps / stepsGoal).clamp(0.0, 1.0) : 0.0,
        value: '${steps.toInt()}/${stepsGoal.toInt()} steps',
        icon: Icons.directions_walk,
        description: progress['stepsDescription'] ?? '',
        route: '/modal/steps',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Water',
        percent: ((progress['water'] ?? 0) / (progress['waterGoal'] ?? 1))
            .toDouble()
            .clamp(0.0, 1.0),
        value:
            '${(progress['water'] ?? 0).toInt()}/${(progress['waterGoal'] ?? 0).toInt()} glasses',
        icon: Icons.water_drop,
        description: progress['waterDescription'] ?? '',
        route: '/modal/water',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Sleep',
        percent: ((progress['sleep'] ?? 0) / (progress['sleepGoal'] ?? 1))
            .toDouble()
            .clamp(0.0, 1.0),
        value:
            '${(progress['sleep'] ?? 0).toString()}/${(progress['sleepGoal'] ?? 0).toString()} h',
        icon: Icons.bedtime,
        description: progress['sleepDescription'] ?? '',
        route: '/modal/sleep',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Weight',
        percent:
            (((progress['currentWeight'] ?? 0) / (progress['weightGoal'] ?? 1)))
                .toDouble()
                .clamp(0.0, 1.0),
        value:
            '${(progress['currentWeight'] ?? 0).toString()}/${(progress['weightGoal'] ?? 0).toString()} kg',
        icon: Icons.scale,
        description: progress['weightDescription'] ?? '',
        route: '/modal/weight',
        userId: widget.userId,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: FixedSizes.box100(context) * 2, // ~200.h
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: cards,
          ),
        ),
        SizedBox(height: FixedSizes.box8(context)),
        SmoothPageIndicator(
          controller: _pageController,
          count: cards.length,
          effect: ExpandingDotsEffect(
            dotWidth: FixedSizes.box8(context),
            dotHeight: FixedSizes.box8(context),
            activeDotColor: AppTheme.colors['gradientTextStart']!,
            dotColor: AppTheme.colors['secondaryText']!.withOpacity(0.5),
            spacing: FixedSizes.box8(context),
          ),
        ),
      ],
    );
  }
}
