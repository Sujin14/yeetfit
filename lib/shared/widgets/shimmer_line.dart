import 'package:flutter/material.dart';
import 'shimmer_box.dart';

/// Text-line placeholder; full width unless [width] is given.
class ShimmerLine extends StatelessWidget {
  final double height;
  final double borderRadius;
  final double? width;

  const ShimmerLine({
    super.key,
    this.height = 16,
    this.borderRadius = 8,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width ?? double.infinity,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
