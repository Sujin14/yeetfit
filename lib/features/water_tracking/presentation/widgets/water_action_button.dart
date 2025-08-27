import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class WaterActionButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WaterActionButtons({super.key, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.remove_circle,
            size: FixedSizes.icon32(context),
            color: AppTheme.colors['deepOrange'],
          ),
          tooltip: 'Remove Glass',
        ),
        SizedBox(width: FixedSizes.box30(context)),
        IconButton(
          onPressed: onAdd,
          icon: Icon(
            Icons.add_circle,
            size: FixedSizes.icon32(context),
            color: AppTheme.colors['teal'],
          ),
          tooltip: 'Add Glass',
        ),
      ],
    );
  }
}
