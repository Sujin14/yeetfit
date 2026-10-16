import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/routes/auth_route_constants.dart';
import 'package:yeetfit/core/routes/settings_route_constants.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

/// Shows snackbars and performs follow-up navigation for settings actions.
///
/// Settings screens stack on top of each other, so only the listener on the
/// topmost route reacts.
class SettingsFeedbackListener extends ConsumerWidget {
  final Widget child;

  const SettingsFeedbackListener({super.key, required this.child});

  static String _successMessage(SettingsAction action) => switch (action) {
    SettingsAction.basicInfoSaved => 'Basic information saved',
    SettingsAction.foodPreferencesSaved => 'Food preferences saved',
    SettingsAction.fitnessGoalUpdated => 'Fitness goal updated',
    SettingsAction.profileImageUpdated => 'Profile photo updated',
    SettingsAction.accountDeleted => 'Account deleted successfully',
    SettingsAction.loggedOut => 'Logged out successfully',
  };

  static String? _redirectFor(SettingsAction action) => switch (action) {
    SettingsAction.accountDeleted ||
    SettingsAction.loggedOut => AuthRouteConstants.root,
    _ => null,
  };

  /// Form screens close after a successful save and return to wherever they
  /// were opened from (the settings list or the account screen).
  static bool _closesScreen(SettingsAction action) => switch (action) {
    SettingsAction.basicInfoSaved ||
    SettingsAction.foodPreferencesSaved ||
    SettingsAction.fitnessGoalUpdated => true,
    _ => false,
  };

  void _showSnackBar(BuildContext context, String message, Color background) {
    final colors = Theme.of(context).extension<AppColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: colors.onSurface),
        ),
        backgroundColor: background,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(settingsControllerProvider, (_, next) {
      if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
      final colors = Theme.of(context).extension<AppColors>()!;
      switch (next) {
        case AsyncData(value: final action?):
          _showSnackBar(context, _successMessage(action), colors.primary);
          final redirect = _redirectFor(action);
          if (redirect != null) {
            context.go(redirect);
          } else if (_closesScreen(action)) {
            context.canPop()
                ? context.pop()
                : context.go(SettingsRouteConstants.root);
          }
        case AsyncError(error: final ReauthenticationRequiredFailure failure):
          _showSnackBar(context, failure.message, colors.error);
        case AsyncError(:final error):
          _showSnackBar(context, '$error', colors.error);
        default:
          break;
      }
    });
    return child;
  }
}
