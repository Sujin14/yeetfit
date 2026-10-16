import 'package:shared_preferences/shared_preferences.dart';

/// Per-account flag recording that the Yana intro has been shown, so a new
/// account on a shared device still gets it.
class YanaIntroLocalDataSource {
  YanaIntroLocalDataSource._();

  static const String shownKeyPrefix = 'yana_intro_shown';

  static final Map<String, bool> _cache = {};

  static String _key(String uid) => '${shownKeyPrefix}_$uid';

  /// The cached flag, or `null` before the first read for [uid].
  static bool? cachedShown(String uid) => _cache[uid];

  static Future<bool> isShown(String uid) async {
    final cached = _cache[uid];
    if (cached != null) return cached;
    final prefs = await SharedPreferences.getInstance();
    return _cache[uid] = prefs.getBool(_key(uid)) ?? false;
  }

  static Future<void> markShown(String uid) async {
    _cache[uid] = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(uid), true);
  }
}
