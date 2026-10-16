import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';
import 'package:yeetfit/shared/widgets/page_dots.dart';

/// Near-black navigation strip below a full-screen pager:
/// Skip | dots | Next, with [finishLabel] replacing Next on the last page.
class PagerNavBar extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final String finishLabel;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const PagerNavBar({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.finishLabel,
    required this.onSkip,
    required this.onNext,
    required this.onFinish,
  });

  static const double _controlHeight = 52;

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage >= pageCount - 1;

    return Container(
      color: Colors.black.withValues(alpha: 0.95),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.paddingOf(context).bottom + 16,
      ),
      child: SizedBox(
        height: _controlHeight,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: isLastPage
                    ? null
                    : TextButton(
                        onPressed: onSkip,
                        child: Text(
                          'Skip',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                        ),
                      ),
              ),
            ),
            PageDots(currentPage: currentPage, pageCount: pageCount),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isLastPage
                      ? SizedBox(
                          key: const ValueKey('finish'),
                          width: 140,
                          child: GradientButton(
                            label: finishLabel,
                            height: 48,
                            borderRadius: 24,
                            onPressed: onFinish,
                          ),
                        )
                      : GlassIconButton(
                          key: const ValueKey('next'),
                          icon: Icons.arrow_forward_rounded,
                          color: Colors.white,
                          tooltip: 'Next',
                          size: _controlHeight,
                          onPressed: onNext,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
