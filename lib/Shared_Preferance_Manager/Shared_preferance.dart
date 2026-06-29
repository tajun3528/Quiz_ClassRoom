import 'package:shared_preferences/shared_preferences.dart';

class SharedPreserance {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyEmail = 'saved_email';

  /// In-memory flag kept in sync with SharedPreferences (no read delay).
  static bool _cachedLoggedIn = false;

  /// Sync getter — returns immediately, no async overhead.
  static bool get isLoggedInSync => _cachedLoggedIn;

  /// Load the persisted flag into the cache at startup.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedLoggedIn = prefs.getBool(_keyLoggedIn) ?? false;
  }

  // --- Save login state ---
  static Future<void> setLoggedIn(bool value) async {
    _cachedLoggedIn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  // --- Check if user is logged in ---
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // --- Save email ---
  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  // --- Get saved email ---
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // --- Clear all saved data ---
  static Future<void> clear() async {
    _cachedLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyEmail);
  }
}