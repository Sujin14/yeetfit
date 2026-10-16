import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

typedef DocumentSection = ({String title, String body});

/// Glass card for long-form text: an intro paragraph followed by titled
/// sections (policies, terms, about copy).
class SettingsDocumentCard extends StatelessWidget {
  final String? intro;
  final List<DocumentSection> sections;

  const SettingsDocumentCard({super.key, this.intro, required this.sections});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium!.copyWith(
      color: colors.textSecondary,
      height: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (intro != null)
              Text(
                intro!,
                style: textTheme.bodyLarge!.copyWith(
                  color: colors.onBackground,
                  height: 1.5,
                ),
              ),
            for (final (index, section) in sections.indexed) ...[
              if (index > 0 || intro != null) const SizedBox(height: 20),
              Text(
                section.title,
                style: textTheme.titleMedium!.copyWith(
                  color: colors.onBackground,
                ),
              ),
              const SizedBox(height: 6),
              Text(section.body, style: bodyStyle),
            ],
          ],
        ),
      ),
    );
  }
}
