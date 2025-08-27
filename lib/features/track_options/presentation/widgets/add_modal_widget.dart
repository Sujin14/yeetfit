import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/drag_handle.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';
import '../../../../utils/fixed_sizes.dart';
import 'track_button.dart';

class AddModalWidget extends StatelessWidget {
  const AddModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: AppTheme.colors['lightBackground']!,
      padding: EdgeInsets.all(FixedSizes.box16(context)),
      borderRadius: FixedSizes.radius24(context),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DragHandle(),
            Text(
              'Track Your Progress',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font20(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.colors['primarytext'],
              ),
            ),
            SizedBox(height: FixedSizes.box24(context)),
            trackButton(
              context,
              icon: Icons.local_dining,
              label: 'Add Meal',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/food'),
            ),
            SizedBox(height: FixedSizes.box12(context)),
            trackButton(
              context,
              icon: Icons.bed,
              label: 'Add Sleep',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/sleep'),
            ),
            SizedBox(height: FixedSizes.box12(context)),
            trackButton(
              context,
              icon: Icons.directions_walk,
              label: 'Add Steps',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/steps'),
            ),
            SizedBox(height: FixedSizes.box12(context)),
            trackButton(
              context,
              icon: Icons.water_drop,
              label: 'Add Water',
              color: AppTheme.colors['teal'] ?? Colors.teal,
              onPressed: () => context.push('/modal/water'),
            ),
            SizedBox(height: FixedSizes.box12(context)),
            trackButton(
              context,
              icon: Icons.scale,
              label: 'Add Weight',
              color: AppTheme.colors['gradientTextMiddle'] ?? Colors.blue,
              onPressed: () => context.push('/modal/weight'),
            ),
          ],
        ),
      ),
    );
  }
}
