import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/theme/theme.dart';

class WaterActionButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WaterActionButtons({
    super.key,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.remove_circle,
            size: 32,
            color: AppTheme.colors['deepOrange'],
          ),
          tooltip: 'Remove Glass',
        ),
        SizedBox(width: 30.w),
        IconButton(
          onPressed: onAdd,
          icon: Icon(
            Icons.add_circle,
            size: 32,
            color: AppTheme.colors['teal'],
          ),
          tooltip: 'Add Glass',
        ),
      ],
    );
  }
}
