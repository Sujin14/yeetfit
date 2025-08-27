import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class DateSeparator extends StatelessWidget {
  final String dateText;

  const DateSeparator({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: FixedSizes.box12(context)),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: FixedSizes.box16(context),
            vertical: FixedSizes.box4(context),
          ),
          decoration: BoxDecoration(
            color: AppTheme.colors['secondaryAccent']!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(FixedSizes.radius16(context)),
          ),
          child: Text(
            dateText,
            style: AppTheme.textStyles['bodySmall']?.copyWith(
              color: AppTheme.colors['secondaryText'],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
