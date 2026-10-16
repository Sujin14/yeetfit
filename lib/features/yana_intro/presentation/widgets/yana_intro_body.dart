import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yeetfit/shared/widgets/pager_nav_bar.dart';
import 'yana_intro_page.dart';

/// Three swipeable full-screen intro pages above the navigation strip.
class YanaIntroBody extends StatefulWidget {
  final VoidCallback onComplete;

  const YanaIntroBody({super.key, required this.onComplete});

  @override
  State<YanaIntroBody> createState() => _YanaIntroBodyState();
}

class _YanaIntroBodyState extends State<YanaIntroBody> {
  static const _pages = [
    YanaIntroPage(
      imagePath: 'assets/images/yana_wave.webp',
      message:
          "Hey! I'm Yana 👋 I'm your personal fitness coach inside Yeetfit. "
          "I'll guide you, track your progress, and keep you motivated every "
          'single day.',
    ),
    YanaIntroPage(
      imagePath: 'assets/images/yana_full.webp',
      message:
          'Track everything that matters 📊 Log your steps, sleep, water and '
          "meals daily. I'll calculate your Recovery Score every morning so "
          'you know exactly how hard to push.',
    ),
    YanaIntroPage(
      imagePath: 'assets/images/yana_avatar.webp',
      message:
          "Ready to start? 💪 Your dashboard is all set. I'm always here — "
          'just tap the chat icon anytime you need advice, a workout plan, '
          'or some motivation.',
    ),
  ];

  final _pageController = PageController();
  int _currentPage = 0;
  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imagesPrecached) return;
    _imagesPrecached = true;
    // Decode pages 2–3 up front so swiping never waits on an image.
    for (final page in _pages) {
      precacheImage(AssetImage(page.imagePath), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Images run under the status bar, so keep its icons light.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (_, index) => RepaintBoundary(child: _pages[index]),
            ),
          ),
          PagerNavBar(
            currentPage: _currentPage,
            pageCount: _pages.length,
            finishLabel: "Let's go!",
            onSkip: widget.onComplete,
            onNext: _nextPage,
            onFinish: widget.onComplete,
          ),
        ],
      ),
    );
  }
}
