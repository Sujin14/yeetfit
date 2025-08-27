import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

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
                width: FixedSizes.box100(context),
                height: FixedSizes.box100(context),
              ),
            ),
            SizedBox(width: FixedSizes.spacing(context)),
            AnimatedOpacity(
              opacity: _showName ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(
                'assets/images/splash_text.png',
                width: FixedSizes.box100(context) * 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
