import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { DARK, LIGHT }

class ThemeState extends ChangeNotifier {
  bool isDarkTheme = false;

  ThemerState() {
    getTheme().then((type) {
      isDarkTheme = type == ThemeType.DARK;
      notifyListeners();
    });
  }

  ThemeType get theme => isDarkTheme ? ThemeType.DARK : ThemeType.LIGHT;
  set theme(ThemeType type) => setTheme(type);

  void setTheme(ThemeType type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isDarkTheme = type == ThemeType.DARK;
    bool status = await preferences.setBool("isDark", isDarkTheme);
    if (status) notifyListeners();
  }

  Future<ThemeType> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isDarkTheme = preferences.getBool('isDark') ?? false;
    return isDarkTheme ? ThemeType.DARK : ThemeType.LIGHT;
  }
}
