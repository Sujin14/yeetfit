import 'package:flutter/material.dart';

// Centered text used for the plan list's empty and error states.
class PlanListMessage extends StatelessWidget {
  final String message;
  final Color color;

  const PlanListMessage({
    super.key,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(fontSize: 16, color: color),
      ),
    );
  }
}
