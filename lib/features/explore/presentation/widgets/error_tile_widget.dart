import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class ErrorTileWidget extends StatelessWidget {
  final String message;

  const ErrorTileWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: FixedSizes.box12(context),
        horizontal: FixedSizes.box16(context),
      ),
      decoration: BoxDecoration(
        color: (AppTheme.colors['error'])!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(FixedSizes.radius12(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: FixedSizes.icon20(context),
            color: AppTheme.colors['error'],
          ),
          SizedBox(width: FixedSizes.box16(context)),
          Expanded(
            child: Text(
              message,
              style: AppTheme.textStyles['body']?.copyWith(
                    color: AppTheme.colors['error'],
                    fontSize: FixedSizes.font16(context),
                  ) ??
                  TextStyle(
                    fontSize: FixedSizes.font16(context),
                    color: AppTheme.colors['error'],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
