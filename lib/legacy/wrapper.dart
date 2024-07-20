import 'package:drbob/legacy/utils/localization.dart';
import 'package:drbob/legacy/views/tools/big_book.dart';
import 'package:drbob/legacy/views/tools/daily_reflections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/bloc.dart';
import 'views/primary.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Future<SharedPreferences>? prefs;

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
            create: (_) => Bloc(
              prefs.containsKey('theme')
                  ? ThemeData(
                      brightness: Brightness.values.firstWhere(
                          (Brightness x) => x.index == prefs.getInt('theme')),
                    )
                  : ThemeData.light(),
              prefs.containsKey('lang')
                  ? Locale(prefs.getString('lang') ?? 'en')
                  : const Locale('en'),
              prefs,
            ),
            child: const MyApp(),
          );
        } else {
          return const RefreshProgressIndicator();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Bloc>(context).getTheme,
      localizationsDelegates: localeDelegates,
      supportedLocales: supportedLocales,
      locale: Provider.of<Bloc>(context).getLocale,
      localeResolutionCallback:
          (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
        if (Provider.of<Bloc>(context).getPrefs.containsKey('lang')) {
          return Provider.of<Bloc>(context).getLocale;
        } else if (supportedLocales
            .contains(Locale(deviceLocale?.languageCode ?? 'en'))) {
          return Locale(deviceLocale?.languageCode ?? 'en');
        }
        return const Locale('en');
      },
      title: 'Dr. Bob',
      initialRoute: '/',
      // routes: <String, WidgetBuilder>{
      //   '/': (BuildContext context) => PrimaryView(),
      //   '/bb': (BuildContext context) => BigBookView(),
      //   '/dr': (BuildContext context) => DailyReflectionsListView(),
      // },
      onGenerateRoute: (RouteSettings settings) {
        final Tween<Offset> tween = Tween<Offset>(
          begin: const Offset(
            -.6,
            .25,
          ),
          end: const Offset(
            0,
            0,
          ),
        );
        const Duration duration = Duration(
          milliseconds: 500,
        );
        return PageRouteBuilder<Widget>(
          settings: settings,
          pageBuilder: (
            BuildContext _,
            Animation<double> __,
            Animation<double> ___,
          ) =>
              const PrimaryView(),
          transitionsBuilder: (
            BuildContext _,
            Animation<double> anim1,
            Animation<double> anim2,
            Widget child,
          ) {
            Widget destination;
            if (settings.name == '/') {
              destination = const PrimaryView();
            } else if (settings.name == '/bb') {
              destination = const BigBookView();
            } else if (settings.name == '/dr') {
              destination = const DailyReflectionsListView();
            } else {
              throw Exception('YOU BROKE THE PROGRAM!');
            }
            return SlideTransition(
              position: tween.animate(
                CurvedAnimation(
                  parent: anim1,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: destination,
            );
          },
          transitionDuration: duration,
        );
      },
      // debugShowMaterialGrid: true,
      // showPerformanceOverlay: true,
    );
  }
}
