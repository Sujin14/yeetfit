import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/settings/presentation/screens/settings_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/account_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/basic_information_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/goal_settings_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/food_preference_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/about_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/help_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/terms_and_conditions_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/contact_us_screen.dart';
import 'package:yeetfit/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:yeetfit/features/payment/presentation/screens/payment_screen.dart';
import 'settings_route_constants.dart';

// Routes for settings and account features.
List<GoRoute> get settingsRoutes => [
      GoRoute(
        path: SettingsRouteConstants.root,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.account,
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.basicInformation,
        builder: (context, state) => const BasicInformationScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.goalSettings,
        builder: (context, state) => const GoalSettingsScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.foodPreferences,
        builder: (context, state) => const FoodPreferencesScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.payment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.help,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.termsAndConditions,
        builder: (context, state) => const TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.contactUs,
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: SettingsRouteConstants.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ];