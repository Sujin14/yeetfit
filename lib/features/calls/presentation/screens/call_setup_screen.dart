import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeetfit/core/services/call_native_service.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/features/settings/presentation/widgets/settings_page_layout.dart';
import 'package:yeetfit/features/settings/presentation/widgets/settings_section_label.dart';
import 'package:yeetfit/shared/widgets/glass_card.dart';
import 'package:yeetfit/shared/widgets/gradient_button.dart';

/// Guides the user through Android call permissions and a lock-screen test.
class CallSetupScreen extends StatefulWidget {
  const CallSetupScreen({super.key});

  @override
  State<CallSetupScreen> createState() => _CallSetupScreenState();
}

class _CallSetupScreenState extends State<CallSetupScreen>
    with WidgetsBindingObserver {
  CallReadiness? _readiness;
  bool _loading = true;
  bool _testScheduled = false;
  bool _testPassed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refresh());
    }
  }

  Future<void> _refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final readiness = await CallNativeService.getCallReadiness();
    if (!mounted) return;
    setState(() {
      _readiness = readiness;
      _testPassed =
          prefs.getBool(CallNativeService.prefsCallSetupTestPassed) ?? false;
      _loading = false;
    });
  }

  Future<void> _fix(String which) async {
    await CallNativeService.openCallSetting(which);
  }

  Future<void> _scheduleTest() async {
    setState(() => _testScheduled = true);
    await CallNativeService.scheduleTestCall();
  }

  Future<void> _done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(CallNativeService.prefsCallSetupCompleted, true);
    if (mounted) context.pop();
  }

  void _skip() {
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final readiness = _readiness;

    return SettingsPageLayout(
      title: 'Enable incoming calls',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'So your coach\'s calls ring and show on your lock screen, even when YeetFit is closed.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              const SettingsSectionLabel('Required'),
              _ReadinessRow(
                label: 'Notifications',
                ok: readiness?.notificationsEnabled ?? false,
                onFix: () => _fix('notifications'),
              ),
              _ReadinessRow(
                label: 'Call alerts',
                ok: readiness?.channelOk ?? false,
                onFix: () => _fix('channel'),
              ),
              _ReadinessRow(
                label: 'Full-screen call screen',
                ok: readiness?.fullScreenOk ?? false,
                onFix: () => _fix('fullScreen'),
              ),
              _ReadinessRow(
                label: 'Unrestricted battery',
                ok: readiness?.batteryOk ?? false,
                onFix: () => _fix('battery'),
              ),
              if (readiness?.needsOemSetup == true) ...[
                const SettingsSectionLabel('Phone-specific'),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        readiness!.oemInstructions,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'These settings can\'t be checked automatically. Use the test call below to confirm.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () => _fix('oem'),
                        child: const Text('Open phone settings'),
                      ),
                    ],
                  ),
                ),
              ],
              const SettingsSectionLabel('Test'),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tap Test call, then lock your phone. In 10 seconds a test call should ring and appear on your lock screen.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    if (_testScheduled) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Test call coming in 10s — lock your phone now',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (_testPassed) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Test call worked ✓',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: _scheduleTest,
                      child: const Text('Test call'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              GradientButton(label: 'Done', onPressed: _done),
              TextButton(onPressed: _skip, child: const Text('Skip for now')),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadinessRow extends StatelessWidget {
  final String label;
  final bool ok;
  final VoidCallback onFix;

  const _ReadinessRow({
    required this.label,
    required this.ok,
    required this.onFix,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.warning_amber_rounded,
              color: ok ? colors.success : colors.warning,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: colors.onBackground),
              ),
            ),
            if (!ok)
              TextButton(onPressed: onFix, child: const Text('Fix')),
          ],
        ),
      ),
    );
  }
}
