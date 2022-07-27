import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode;

  ThemeMode get mode {
    return _mode;
  }

  set mode(ThemeMode newMode) {
    _mode = newMode;
    SharedPreferences.getInstance().then((prefs) {
      switch (newMode) {
        case ThemeMode.system:
          prefs.setString('theme', 'system');
          break;
        case ThemeMode.light:
          prefs.setString('theme', 'light');
          break;
        case ThemeMode.dark:
          prefs.setString('theme', 'dark');
          break;
      }
    });

    notifyListeners();
  }

  ThemeProvider(this._mode);
}
