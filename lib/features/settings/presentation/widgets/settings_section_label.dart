import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class SettingsSectionLabel extends StatelessWidget {
  final String text;

  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 6),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: colors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
