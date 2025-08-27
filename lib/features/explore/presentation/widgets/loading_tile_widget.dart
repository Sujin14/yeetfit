import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class LoadingTileWidget extends StatelessWidget {
  const LoadingTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: FixedSizes.box12(context),
        horizontal: FixedSizes.box16(context),
      ),
      decoration: BoxDecoration(
        color: AppTheme.colors['cardBackground'],
        borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            size: FixedSizes.icon20(context),
            color: AppTheme.colors['secondaryIcon'],
          ),
          SizedBox(width: FixedSizes.box16(context)),
          Text(
            'Loading...',
            style: AppTheme.textStyles['body']?.copyWith(
                  color: AppTheme.colors['secondaryText'],
                  fontSize: FixedSizes.font16(context),
                ) ??
                TextStyle(
                  fontSize: FixedSizes.font16(context),
                  color: AppTheme.colors['gray'],
                ),
          ),
        ],
      ),
    );
  }
}
