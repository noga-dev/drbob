// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bloc with ChangeNotifier {
  Bloc(
    ThemeData theme,
    Locale locale,
    SharedPreferences prefs,
  ) {
    _theme = theme;
    _locale = locale;
    _preferences = prefs;
    _flnp = FlutterLocalNotificationsPlugin();
  }

  late SharedPreferences _preferences;
  late ThemeData _theme;
  late Locale _locale;
  late FlutterLocalNotificationsPlugin _flnp;

  ThemeData get getTheme => _theme;
  Locale get getLocale => _locale;
  SharedPreferences get getPrefs => _preferences;
  FlutterLocalNotificationsPlugin get flnp => _flnp;
  double get getFontSize => _preferences.containsKey('fontSize')
      ? getPrefs.getDouble('fontSize')!
      : 14;
  DateTime get getSobrietyDate => _preferences.containsKey('sobrietyDateInt')
      ? DateTime.fromMillisecondsSinceEpoch(
          _preferences.getInt('sobrietyDateInt')!)
      : DateTime.now();
  Duration get getSobrietyTime => DateTime.now().difference(getSobrietyDate);

  void notify() {
    notifyListeners();
  }

  void changeTheme(ThemeData data) {
    _theme = data;
    _preferences.setInt('theme', data.brightness.index);
    notifyListeners();
  }

  void changeLocale(Locale data) {
    _locale = data;
    _preferences.setString('lang', data.languageCode);
    notifyListeners();
  }

  void changeFontSize(double fontSize) {
    _preferences.setDouble('fontSize', fontSize);
    notifyListeners();
  }
}
