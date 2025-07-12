import 'package:flutter/material.dart';

import '../../../../shared/widgets/glassmorphic_container.dart';

class WaterTipCard extends StatelessWidget {
  const WaterTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Tip',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(
            'Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
