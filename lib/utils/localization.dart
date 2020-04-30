import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('he'),
  Locale('ru'),
];

String Function(BuildContext context, String string) trans = (BuildContext context, String string) => AppLocalizations.of(
      context,
    ).translate(
      string,
    );

Iterable<LocalizationsDelegate<dynamic>> localeDelegates = <LocalizationsDelegate<dynamic>>[
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
    _sentences = <String, dynamic>{};
    json
        .decode(
      await rootBundle
          .loadString('assets/langs/${locale.languageCode}.json'),
    )
        .forEach((String key, dynamic value) {
      _sentences[key] = value;
    });

    return true;
  }

  String translate(String key) {
    return (_sentences[key] ?? key)  as String;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
