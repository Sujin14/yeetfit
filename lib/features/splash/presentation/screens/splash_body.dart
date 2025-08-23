import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/theme/theme.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  bool _showIcon = false;
  bool _showName = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _showIcon = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _showName = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.colors['white'],
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _showIcon ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Image.asset(
                'assets/icons/app_icon.png',
                width: 100.w,
                height: 100.w,
              ),
            ),
            SizedBox(width: 10.w),
            AnimatedOpacity(
              opacity: _showName ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(
                'assets/images/splash_text.png',
                width: 180.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
