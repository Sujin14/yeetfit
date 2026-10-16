import 'package:flutter/material.dart';
import '../../domain/entities/scanned_meal.dart';
import 'scan_result_card.dart';
import 'scan_result_log_panel.dart';

/// Holds the user's edits to the AI estimate; "Add to log" uses these, not
/// the original [result].
class ScanResultForm extends StatefulWidget {
  final String userId;
  final ScannedMeal result;
  final VoidCallback onRetake;
  final ValueChanged<String> onAdded;

  const ScanResultForm({
    super.key,
    required this.userId,
    required this.result,
    required this.onRetake,
    required this.onAdded,
  });

  @override
  State<ScanResultForm> createState() => _ScanResultFormState();
}

class _ScanResultFormState extends State<ScanResultForm> {
  late ScannedMeal _editedMeal = widget.result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScanResultCard(
          initialResult: widget.result,
          onChanged: (meal) => setState(() => _editedMeal = meal),
        ),
        ScanResultLogPanel(
          userId: widget.userId,
          result: _editedMeal,
          onRetake: widget.onRetake,
          onAdded: widget.onAdded,
        ),
      ],
    );
  }
}
