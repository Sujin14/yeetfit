import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class StepsActionSheet extends StatelessWidget {
  final VoidCallback onSetGoal;
  final VoidCallback onReset;

  const StepsActionSheet({
    super.key,
    required this.onSetGoal,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(FixedSizes.spacing(context)),
      decoration: BoxDecoration(
        color: AppTheme.colors['lightBackground'],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FixedSizes.radius24(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.flag, size: FixedSizes.icon24(context)),
            title: Text(
              'Set Daily Goal',
              style: GoogleFonts.roboto(fontSize: FixedSizes.font16(context)),
            ),
            onTap: onSetGoal,
          ),
          ListTile(
            leading: Icon(Icons.refresh, size: FixedSizes.icon24(context)),
            title: Text(
              'Reset Steps',
              style: GoogleFonts.roboto(fontSize: FixedSizes.font16(context)),
            ),
            onTap: onReset,
          ),
        ],
      ),
    );
  }
}
