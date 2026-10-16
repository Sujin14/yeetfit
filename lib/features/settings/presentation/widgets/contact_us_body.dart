import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';

class ContactUsBody extends StatelessWidget {
  static const _email = 'sujinksureshofcl@gmail.com';

  const ContactUsBody({super.key});

  Future<void> _emailSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      query: 'subject=${Uri.encodeComponent('YeetFit Support')}',
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the mail app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(Icons.mail_outline_rounded, size: 72, color: colors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Contact Us',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge!.copyWith(
              color: colors.onBackground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Have a question or need help? We’re here for you.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge!.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassCard(
            borderRadius: 16,
            padding: EdgeInsets.zero,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => _emailSupport(context),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, color: colors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          _email,
                          style: textTheme.bodyLarge!.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'We typically respond within 24–48 hours.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium!.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
