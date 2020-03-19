import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/tools/big_book.dart';
import 'package:drbob/views/tools/daily_reflections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/Bloc.dart';
import 'utils/localization.dart';
import 'views/primary.dart';

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Future<SharedPreferences> prefs;

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: prefs,
      builder: (BuildContext context, AsyncSnapshot<void> data) {
        if (data.connectionState == ConnectionState.done) {
          final SharedPreferences prefs = data.data as SharedPreferences;
          return ChangeNotifierProvider<Bloc>(
            builder: (_) => Bloc(
              prefs.containsKey('theme')
                  ? ThemeData(
                      brightness: Brightness.values.firstWhere(
                          (Brightness x) => x.index == prefs.getInt('theme')),
                    )
                  : ThemeData.light(),
              prefs.containsKey('lang')
                  ? Locale(prefs.getString('lang'))
                  : const Locale('en'),
              prefs,
            ),
            child: MyApp(),
          );
        } else {
          return const RefreshProgressIndicator();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locale Function(
            Locale deviceLocale, Iterable<Locale> supportedLocales)
        localeResolutionCallback =
        (Locale deviceLocale, Iterable<Locale> supportedLocales) {
      if (Provider.of<Bloc>(context).getPrefs.containsKey('lang')) {
        return Provider.of<Bloc>(context).getLocale;
      } else if (supportedLocales.contains(Locale(deviceLocale.languageCode))) {
        return Locale(deviceLocale.languageCode);
      }
      return const Locale('en');
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Bloc>(context).getTheme,
      localizationsDelegates: localeDelegates,
      supportedLocales: supportedLocales,
      locale: Provider.of<Bloc>(context).getLocale,
      localeResolutionCallback: localeResolutionCallback,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => PrimaryView(),
        '/bb': (BuildContext context) => BigBookView(),
        '/dr': (BuildContext context) => DailyReflectionsListView(),
      },
      title: 'Dr. Bob',
      // debugShowMaterialGrid: true,
      // showPerformanceOverlay: true,
    );
  }
}
