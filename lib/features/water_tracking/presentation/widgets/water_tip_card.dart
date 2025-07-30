import 'package:flutter/material.dart';
import 'package:yeetfit/shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterTipCard extends StatelessWidget {
  const WaterTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['navBarActive']!,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Tip',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.colors['primaryText']!.withOpacity(0.8)),
          ),
          SizedBox(height: 6),
          Text(
            'Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!',
            style: TextStyle(color: AppTheme.colors['primaryText']!.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}