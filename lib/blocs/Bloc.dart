import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bloc with ChangeNotifier {
  SharedPreferences _preferences;
  ThemeData _theme;
  Locale _locale;

  Bloc(
    ThemeData theme,
    Locale locale,
    SharedPreferences prefs,
  ) {
    this._theme = theme;
    this._locale = locale;
    this._preferences = prefs;
  }

  ThemeData get getTheme => _theme;
  Locale get getLocale => _locale;
  SharedPreferences get getPrefs => _preferences;

  void notify() {
    notifyListeners();
  }

  void changeTheme(ThemeData data) {
    this._theme = data;
    this._preferences.setInt("theme", data.brightness.index);
    notifyListeners();
  }

  void changeLocale(Locale data) {
    this._locale = data;
    this._preferences.setString("lang", data.languageCode);
    notifyListeners();
  }
}
