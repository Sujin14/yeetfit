import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';

class WaterCircularIndicator extends StatelessWidget {
  final double progress;
  const WaterCircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: FixedSizes.box150(context),
                height: FixedSizes.box150(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colors['transparent'],
                ),
              ),
              SizedBox(
                width: FixedSizes.box150(context),
                height: FixedSizes.box150(context),
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: FixedSizes.box20(context),
                  backgroundColor: AppTheme.colors['white']?.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(AppTheme.colors['aquaBlue']),
                ),
              ),
              GlassmorphicContainer(
                color: AppTheme.colors['teal']!,
                padding: EdgeInsets.all(0),
                borderRadius: FixedSizes.radius50(context),
                child: Container(
                  width: FixedSizes.box80(context),
                  height: FixedSizes.box80(context),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: FixedSizes.icon40(context),
                    color: AppTheme.colors['aquaBlue'],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: FixedSizes.box20(context)),
          Text(
            '1 Glass = 250 ml',
            style: TextStyle(
              color: AppTheme.colors['primaryText']?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
