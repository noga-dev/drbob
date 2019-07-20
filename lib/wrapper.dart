import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/Bloc.dart';
import 'utils/localization.dart';
import 'views/home.dart';

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Future<SharedPreferences> prefs;

  @override
  initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (context, data) {
        if (data.connectionState == ConnectionState.done) {
          var prefs = data.data;
          return ChangeNotifierProvider<Bloc>(
            builder: (_) => Bloc(
              prefs.containsKey("theme")
                  ? ThemeData(
                      brightness: Brightness.values
                          .firstWhere((x) => x.index == prefs.getInt("theme")),
                    )
                  : ThemeData.light(),
              prefs.containsKey("lang")
                  ? Locale(prefs.getString("lang"))
                  : Locale("en"),
              prefs,
            ),
            child: MyApp(),
          );
        } else {
          return RefreshProgressIndicator();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localeResolutionCallback =
        (Locale deviceLocale, Iterable<Locale> supportedLocales) {
      if (Provider.of<Bloc>(context).getPrefs.containsKey("lang")) {
        return Provider.of<Bloc>(context).getLocale;
      } else if (supportedLocales.contains(Locale(deviceLocale.languageCode))) {
        return Locale(deviceLocale.languageCode);
      }
      return Locale("en");
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Bloc>(context).getTheme,
      localizationsDelegates: localeDelegates,
      supportedLocales: supportedLocales,
      locale: Provider.of<Bloc>(context).getLocale,
      localeResolutionCallback: localeResolutionCallback,
      home: HomeView(),
    );
  }
}
