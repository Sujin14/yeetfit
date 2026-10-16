import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/settings_route_constants.dart';
import '../providers/app_version_provider.dart';
import '../widgets/about_body.dart';
import '../widgets/settings_page_layout.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionLabel = ref
        .watch(appVersionProvider)
        .when(
          data: (info) => 'Version ${info.version}+${info.buildNumber}',
          loading: () => 'Version …',
          error: (_, _) => 'Version unavailable',
        );

    return SettingsPageLayout(
      title: 'About',
      child: AboutBody(
        versionLabel: versionLabel,
        onPrivacyTap: () => context.push(SettingsRouteConstants.privacyPolicy),
        onTermsTap: () =>
            context.push(SettingsRouteConstants.termsAndConditions),
      ),
    );
  }
}
