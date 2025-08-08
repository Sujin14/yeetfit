import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/theme/theme.dart';
import '../../../steps_tracking/presentation/providers/steps_provider.dart';
import 'progress_card.dart';

class ProgressCardsList extends ConsumerStatefulWidget {
  final Map<String, dynamic> progress;
  final String userId;

  const ProgressCardsList({super.key, required this.progress, required this.userId});

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
    print('ProgressCardsList: Initializing for userId=${widget.userId}');
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      print('ProgressCardsList: Page changed to $index for userId=${widget.userId}');
    });
    _startAutoSwipe();
  }

  @override
  void dispose() {
    print('ProgressCardsList: Disposing for userId=${widget.userId}');
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(stepsCountProvider(widget.userId)).value ?? 0;
    final stepsGoal = ref.watch(stepsGoalProvider(widget.userId)).value ?? 10000;

    final cards = [
      ProgressCard(
        title: 'Steps',
        percent: (steps / stepsGoal).clamp(0.0, 1.0),
        value: '$steps/$stepsGoal',
        icon: Icons.directions_walk,
        description: widget.progress['stepsDescription'] ?? 'Steps improve heart health',
        route: '/modal/steps',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Water',
        percent: (widget.progress['water'] / widget.progress['waterGoal']).toDouble().clamp(0.0, 1.0),
        value: '${widget.progress['water'].toInt()} glasses/${widget.progress['waterGoal'].toInt()} glasses',
        icon: Icons.water_drop,
        description: widget.progress['waterDescription'],
        route: '/modal/water',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Calories',
        percent: (widget.progress['calories'] / widget.progress['caloriesGoal']).toDouble().clamp(0.0, 1.0),
        value: '${widget.progress['calories'].toInt()}/${widget.progress['caloriesGoal'].toInt()} kcal',
        icon: Icons.local_fire_department,
        description: widget.progress['caloriesDescription'],
        route: null,
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Sleep',
        percent: (widget.progress['sleep'] / widget.progress['sleepGoal']).toDouble().clamp(0.0, 1.0),
        value: '${widget.progress['sleep']}h/${widget.progress['sleepGoal']}h',
        icon: Icons.bedtime,
        description: widget.progress['sleepDescription'],
        route: '/modal/sleep',
        userId: widget.userId,
      ),
      ProgressCard(
        title: 'Weight',
        percent: (widget.progress['currentWeight'] / widget.progress['weightGoal']).toDouble().clamp(0.0, 1.0),
        value: '${widget.progress['currentWeight']}kg/${widget.progress['weightGoal']}kg',
        icon: Icons.scale,
        description: widget.progress['weightDescription'],
        route: '/modal/weight',
        userId: widget.userId,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 180.h,
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
            activeDotColor: AppTheme.colors['gradientTextStart']!,
            dotColor: AppTheme.colors['secondaryText']!.withOpacity(0.5),
            spacing: 4.w,
          ),
        ),
      ],
    );
  }
}