import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService({required SharedPreferences preferences})
      : _preferences = preferences;

  static const String keyIsDarkTheme = 'isDarkTheme';

  Future<bool> get isDarkTheme async {
    return _preferences.getBool(keyIsDarkTheme) ?? false;
  }

  Future<void> setDarkTheme(bool isDarkTheme) async {
    await _preferences.setBool(keyIsDarkTheme, isDarkTheme);
  }
}
