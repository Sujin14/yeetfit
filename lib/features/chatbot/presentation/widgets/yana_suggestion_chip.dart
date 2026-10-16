import 'package:flutter/material.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Tappable glass prompt that pre-fills the chat input with [label]. Styled
/// light-on-dark for the image background of the empty chat.
class YanaSuggestionChip extends StatelessWidget {
  final String label;
  final ValueChanged<String> onSelected;

  const YanaSuggestionChip({
    super.key,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelected(label),
        child: GlassCard(
          borderRadius: 20,
          opacity: 0.15,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.smd,
            horizontal: AppSpacing.md,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
