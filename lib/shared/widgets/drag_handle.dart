import 'package:flutter/material.dart';
import '../../utils/fixed_sizes.dart';
import '../theme/theme.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: FixedSizes.box40(context),
        height: FixedSizes.box6(context),
        margin: EdgeInsets.only(bottom: FixedSizes.box16(context)),
        decoration: BoxDecoration(
          color:
              AppTheme.colors['onSurface']?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(FixedSizes.box2(context)),
        ),
      ),
    );
  }
}
