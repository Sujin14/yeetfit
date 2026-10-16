import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CoachSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CoachSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.md,
        AppSpacing.screenEdge,
        AppSpacing.xs,
      ),
      child: YeetTextField(
        hintText: 'Search by name or specialization',
        prefixIcon: Icons.search,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
      ),
    );
  }
}
