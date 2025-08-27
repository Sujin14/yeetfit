import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class ErrorCardWidget extends StatelessWidget {
  final String error;
  const ErrorCardWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: FixedSizes.box200(context),
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
        colors: [
          AppTheme.colors['borderGradientStart']!,
          AppTheme.colors['borderGradientEnd']!,
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(FixedSizes.box16(context)),
        child: Text(
          'Error: $error',
          style: AppTheme.textStyles['body']?.copyWith(
            color: AppTheme.colors['error'],
            fontSize: FixedSizes.font16(context),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
