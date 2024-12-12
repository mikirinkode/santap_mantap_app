import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService({required SharedPreferences preferences})
      : _preferences = preferences;

  static const String keyIsDarkTheme = 'isDarkTheme';
  static const String keyIsReminderActive= 'isReminderActive';

  Future<bool> get isDarkTheme async {
    return _preferences.getBool(keyIsDarkTheme) ?? false;
  }

  Future<bool> get isReminderActive async {
    return _preferences.getBool(keyIsReminderActive) ?? false;
  }

  Future<void> setDarkTheme(bool isDarkTheme) async {
    await _preferences.setBool(keyIsDarkTheme, isDarkTheme);
  }

  Future<void> setReminderActive(bool isReminderActive) async {
    await _preferences.setBool(keyIsReminderActive, isReminderActive);
  }
}
