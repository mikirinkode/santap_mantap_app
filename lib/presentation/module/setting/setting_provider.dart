import 'package:flutter/foundation.dart';
import 'package:santap_mantap_app/data/source/local/shared_preferences_service.dart';
import 'package:santap_mantap_app/di/injection.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferencesService _service =
      Injection.instance.sharedPreferencesService;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;


  Future<void> checkIsDarkTheme() async {
    _isDarkTheme = await _service.isDarkTheme;
    notifyListeners();
  }

  void onChangeTheme(bool value) {
    _isDarkTheme = value;
    _service.setDarkTheme(value);
    notifyListeners();
  }
}
