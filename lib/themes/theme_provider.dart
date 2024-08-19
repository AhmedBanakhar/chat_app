import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/ligth_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ligthMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == ligthMode) {
      themeData = darkMode;
    } else {
      themeData = ligthMode;
    }
  }
}
