import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/theme/theme.dart';
import 'progress_card.dart';

class ProgressCardsList extends StatefulWidget {
  final Map<String, dynamic> progress;

  const ProgressCardsList({super.key, required this.progress});

  @override
  _ProgressCardsListState createState() => _ProgressCardsListState();
}

class _ProgressCardsListState extends State<ProgressCardsList> {
  final PageController _pageController = PageController();
  Timer? _autoSwipeTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 3) {
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
    final cards = [
      ProgressCard(
        title: 'Steps',
        percent: (widget.progress['steps'] / widget.progress['stepsGoal'])
            .toDouble(),
        value: '${widget.progress['steps']}/${widget.progress['stepsGoal']}',
        icon: Icons.directions_walk,
        description: widget.progress['stepsDescription'],
      ),
      ProgressCard(
        title: 'Water',
        percent: (widget.progress['water'] / widget.progress['waterGoal'])
            .toDouble(),
        value: '${widget.progress['water']}L/${widget.progress['waterGoal']}L',
        icon: Icons.water_drop,
        description: widget.progress['waterDescription'],
      ),
      ProgressCard(
        title: 'Calories',
        percent: (widget.progress['calories'] / widget.progress['caloriesGoal'])
            .toDouble(),
        value:
            '${widget.progress['calories']}/${widget.progress['caloriesGoal']} kcal',
        icon: Icons.local_fire_department,
        description: widget.progress['caloriesDescription'],
      ),
      ProgressCard(
        title: 'Sleep',
        percent: (widget.progress['sleep'] / widget.progress['sleepGoal'])
            .toDouble(),
        value: '${widget.progress['sleep']}h/${widget.progress['sleepGoal']}h',
        icon: Icons.bedtime,
        description: widget.progress['sleepDescription'],
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
