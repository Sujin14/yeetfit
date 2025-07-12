import 'package:flutter/material.dart';

class WaterActionButtons extends StatelessWidget {
  const WaterActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.remove_circle,
            size: 32,
            color: Color(0xFFFF5722),
          ),
          tooltip: 'Remove Glass',
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add_circle,
            size: 32,
            color: Color(0xFF26A69A),
          ),
          tooltip: 'Add Glass',
        ),
      ],
    );
  }
}