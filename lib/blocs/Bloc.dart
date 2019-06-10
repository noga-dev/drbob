import 'package:flutter/material.dart';

class Bloc with ChangeNotifier {
  ThemeData _theme;
  Locale _locale;

  Bloc(
    ThemeData theme,
    Locale locale,
  ) {
    this._theme = theme;
    this._locale = locale;
  }

  ThemeData get getTheme => _theme;
  Locale get getLocale => _locale;

  void changeTheme(ThemeData data) {
    this._theme = data;
    notifyListeners();
  }

  void changeLocale(Locale data) {
    this._locale = data;
    notifyListeners();
  }
}