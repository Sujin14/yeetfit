import 'package:flutter/material.dart';

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
          icon: const Icon(
            Icons.remove_circle,
            size: 32,
            color: Color(0xFFFF5722),
          ),
          tooltip: 'Remove Glass',
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: onAdd,
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
