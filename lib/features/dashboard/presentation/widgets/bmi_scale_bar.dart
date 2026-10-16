import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Horizontal BMI scale (15–35) split into WHO bands with a marker at [bmi].
class BmiScaleBar extends StatelessWidget {
  final double bmi;

  const BmiScaleBar({super.key, required this.bmi});

  static const double _min = 15;
  static const double _max = 35;
  static const double _markerSize = 14;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final position = ((bmi - _min) / (_max - _min)).clamp(0.0, 1.0);

    // Flex values are the band widths in tenths of a BMI point.
    final bands = [
      (35, colors.bmiUnderweight),
      (65, colors.bmiNormal),
      (50, colors.bmiOverweight),
      (50, colors.bmiObese),
    ];

    return SizedBox(
      height: _markerSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final left = position * (constraints.maxWidth - _markerSize);
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  children: [
                    for (final (flex, color) in bands)
                      Expanded(
                        flex: flex,
                        child: Container(height: 6, color: color),
                      ),
                  ],
                ),
              ),
              Positioned(
                left: left,
                child: Container(
                  width: _markerSize,
                  height: _markerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.onBackground,
                    border: Border.all(color: colors.background, width: 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
