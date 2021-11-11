import 'package:flutter/material.dart';
import 'package:moviebox/src/shared/util/utilities.dart';

import 'theme_preferences.dart';

class MyTheme extends ChangeNotifier {
   bool _isDark = true;
    bool get isDark => _isDark;
   ThemePreferences _preferences= new ThemePreferences();

  ThemeMode currentMode(){
    return isDark?ThemeMode.dark:ThemeMode.light;
  }
  MyTheme(){
     _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }
  void switchTheme(){
    _isDark = !_isDark;
    print(_isDark);
        _preferences.setTheme(_isDark);
    notifyListeners();
  }

    getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
  
}