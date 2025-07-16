import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: GlassmorphicContainer(
          width: 0.9.sw,
          height: 60.h,
          borderRadius: 20.r,
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
              // Animated background for selected icon
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left:
                    (currentIndex * (0.9.sw / children.length)) +
                    (0.9.sw / children.length - 40.w) / 2,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.colors['navBarActive']!.withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.colors['navBarActive']!.withOpacity(
                          0.2,
                        ),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // Icons row
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
