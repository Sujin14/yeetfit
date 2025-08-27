import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class AboutCard extends StatelessWidget {
  final VoidCallback onTap;

  const AboutCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: FixedSizes.box8(context)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: AppTheme.textStyles['subtitle']!.copyWith(
                          fontSize: FixedSizes.font18(context),
                          color: AppTheme.colors['primaryText'],
                        ),
                      ),
                      SizedBox(height: FixedSizes.box8(context)),
                      Text(
                        'Learn more about our app',
                        style: AppTheme.textStyles['body']!.copyWith(
                          fontSize: FixedSizes.font14(context),
                          color: AppTheme.colors['secondaryText'],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.colors['primaryText'],
                  size: FixedSizes.icon16(context),
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.colors['borderGradientStart']),
        ],
      ),
    );
  }
}
