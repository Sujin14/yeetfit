import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../utils/fixed_sizes.dart';
import '../theme/theme.dart';

class BottomNavBarUI extends StatelessWidget {
  final List<Widget> children;
  final int currentIndex;

  const BottomNavBarUI({
    super.key,
    required this.children,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: FixedSizes.box20(context),
          vertical: FixedSizes.box16(context),
        ),
        child: GlassmorphicContainer(
          width: FixedSizes.box100(context) * 3.5,
          height: FixedSizes.box48(context),
          borderRadius: FixedSizes.borderRadius(context),
          blur: 20,
          alignment: Alignment.center,
          border: 1.5,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.colors['navigationAccent']!,
              AppTheme.colors['navigationAccent']!.withOpacity(0.8),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.colors['borderGradientStart']!,
              AppTheme.colors['borderGradientEnd']!,
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: (currentIndex *
                        (FixedSizes.box100(context) * 3.5 / children.length)) +
                    ((FixedSizes.box100(context) * 3.5 / children.length) -
                            FixedSizes.box40(context)) /
                        2,
                child: Container(
                  width: FixedSizes.box40(context),
                  height: FixedSizes.box40(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppTheme.colors['navBarActive']!.withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.colors['navBarActive']!
                            .withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
