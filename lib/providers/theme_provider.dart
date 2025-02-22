import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);
  }

  ThemeData get darkTheme {
    return ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark);
  }
}
