import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

typedef LegalSection = ({String title, String body});

/// Scrollable legal copy. One [SelectableText] so the whole page can be copied.
class SettingsSelectableDocument extends StatelessWidget {
  final String updated;
  final String intro;
  final List<LegalSection> sections;

  const SettingsSelectableDocument({
    super.key,
    required this.updated,
    required this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final body = textTheme.bodyMedium!.copyWith(
      color: colors.textSecondary,
      height: 1.5,
    );
    final heading = textTheme.titleMedium!.copyWith(
      color: colors.onBackground,
      fontWeight: FontWeight.w700,
      height: 1.4,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: SelectableText.rich(
          TextSpan(
            style: body,
            children: [
              TextSpan(text: '$updated\n\n'),
              TextSpan(text: intro),
              for (final section in sections) ...[
                TextSpan(text: '\n\n${section.title}\n', style: heading),
                TextSpan(text: section.body),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
