import 'package:flutter/material.dart';
import 'yana_suggestion_chip.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Greeting, starter prompts and disclaimer, anchored to the lower part of
/// the empty chat over [YanaChatBackground].
class YanaEmptyChatContent extends StatelessWidget {
  final ValueChanged<String> onSuggestionSelected;

  const YanaEmptyChatContent({super.key, required this.onSuggestionSelected});

  static const List<String> _suggestions = [
    'How do I improve my recovery score?',
    'What should I eat before a workout?',
    'Create a 5-day workout plan for me',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Bottom-aligned and scrollable, so it hugs the input and survives the
    // keyboard shrinking the space above it.
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hi! I'm Yana 👋",
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.smd),
            Text(
              'Ask me anything about fitness,\nnutrition or recovery.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge!.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final suggestion in _suggestions)
                  YanaSuggestionChip(
                    label: suggestion,
                    onSelected: onSuggestionSelected,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Yana may occasionally make mistakes.\n'
              'Always consult a professional for medical advice.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall!.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
