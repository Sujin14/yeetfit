import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/theme.dart';

class BottomNavBarUI extends StatelessWidget {
  final List<Widget> children;

  const BottomNavBarUI({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16.h),
        child: GlassmorphicContainer(
          width: width * 0.9,
          height: 60.h,
          borderRadius: 20.r,
          blur: 20,
          alignment: Alignment.center,
          border: 5,
          linearGradient: LinearGradient(
            colors: [
              AppTheme.colors['navigationAccent']!,
              AppTheme.colors['navigationAccent']!,
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              Color.fromRGBO(128, 222, 234, 0.3),
              Color.fromRGBO(207, 236, 241, 0.1),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      ),
    );
  }
}
