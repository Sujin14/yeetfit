import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

class AccountHeaderCard extends StatelessWidget {
  static const double _avatarSize = 64;

  final String name;
  final String? email;
  final String? photoUrl;
  final VoidCallback? onEditPhoto;

  const AccountHeaderCard({
    super.key,
    required this.name,
    this.email,
    this.photoUrl,
    this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: 20,
        child: Row(
          children: [
            Semantics(
              button: onEditPhoto != null,
              label: 'Change profile photo',
              child: GestureDetector(
                onTap: onEditPhoto,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: _avatarSize / 2,
                      backgroundColor: colors.primary.withValues(alpha: 0.25),
                      foregroundImage: photoUrl != null
                          ? NetworkImage(photoUrl!)
                          : null,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: textTheme.headlineMedium!.copyWith(
                          color: colors.onBackground,
                        ),
                      ),
                    ),
                    if (onEditPhoto != null)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 12,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Yeetfit user',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge!.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  if (email != null && email!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
