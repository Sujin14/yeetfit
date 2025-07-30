import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

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
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colors['transparent']!,
                ),
              ),
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20,
                  backgroundColor: AppTheme.colors['white']!.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(AppTheme.colors['aquaBlue']),
                ),
              ),
              GlassmorphicContainer(
                color: const Color(0xFF26A69A),
                padding: const EdgeInsets.all(0),
                borderRadius: 40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 40,
                    color: AppTheme.colors['aquaBlue'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '1 Glass = 250 ml',
            style: GoogleFonts.roboto(color: AppTheme.colors['primaryText']!.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}