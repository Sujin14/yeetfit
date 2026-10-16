import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// Per-account completion flags for Yana's tours, plus start/skip helpers
/// that record which tour is running on the shared `ShowCaseWidget`.
class WalkthroughController {
  WalkthroughController._();

  static const String dashboard = 'walkthrough_dashboard';
  static const String progress = 'walkthrough_progress';
  static const String challenges = 'walkthrough_challenges';
  static const String explore = 'walkthrough_explore';

  static ({String key, String uid})? _activeTour;

  static Future<bool> shouldShow(String key, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('${key}_$uid') ?? false);
  }

  static Future<void> markDone(String key, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${key}_$uid', true);
  }

  static void start(
    BuildContext context, {
    required String key,
    required String uid,
    required List<GlobalKey> targets,
  }) {
    _activeTour = (key: key, uid: uid);
    ShowCaseWidget.of(context).startShowCase(targets);
  }

  /// Wire to `ShowCaseWidget.onFinish`, which fires after the last step.
  static void finishActive() {
    final tour = _activeTour;
    _activeTour = null;
    if (tour != null) markDone(tour.key, tour.uid);
  }

  /// showcaseview 3.x's `dismiss()` doesn't fire `onFinish`, so skipping
  /// records completion here.
  static void skip(BuildContext context) {
    ShowCaseWidget.of(context).dismiss();
    finishActive();
  }
}
