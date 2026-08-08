import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsViewModel(this._prefs) {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  void _loadSettings() {
    final isDark = _prefs.getBool('isDark') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    _notificationsEnabled = isEnabled;
    await _prefs.setBool('notificationsEnabled', isEnabled);
    notifyListeners();
  }
}
