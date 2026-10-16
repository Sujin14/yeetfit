import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class CoachCertificationList extends StatelessWidget {
  final List<String> certifications;

  const CoachCertificationList({super.key, required this.certifications});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (certifications.isEmpty) {
      return Text(
        'No certifications listed',
        style: textTheme.bodyMedium!.copyWith(color: colors.textMuted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final certification in certifications)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 20,
                  color: colors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    certification,
                    style: textTheme.bodyLarge!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
