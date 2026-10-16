import 'package:flutter/material.dart';

/// 20px inline spinner, only for buttons whose action is running. Screen and
/// card loading states use shimmer skeletons instead.
class ButtonSpinner extends StatelessWidget {
  final Color color;

  const ButtonSpinner({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
