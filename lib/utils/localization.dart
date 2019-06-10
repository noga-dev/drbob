import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const supportedLocales = [
  const Locale('en'),
  const Locale('he'),
  const Locale('ru'),
];

var trans = (BuildContext context, String string) => AppLocalizations.of(
      (context),
    ).translate(
      string,
    );

Iterable<LocalizationsDelegate> localeDelegates = [
  const AppLocalizationsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, dynamic> _sentences;

  Future<bool> load() async {
    this._sentences = Map();
    json
        .decode(
      await rootBundle
          .loadString('assets/langs/${this.locale.languageCode}.json'),
    )
        .forEach((String key, dynamic value) {
      this._sentences[key] = value;
    });

    return true;
  }

  String translate(String key) {
    return this._sentences[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
