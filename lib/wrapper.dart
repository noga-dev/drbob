import 'package:aadr/views/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blocs/Bloc.dart';
import 'utils/localization.dart';
import 'views/home.dart';
import 'views/settings.dart';
import 'views/tools/daily_reflections.dart';

// ANCHOR Redundant?
var routes = {
  "/": (context) => AppHome(),
  "/home": (context) => HomeView(),
  "/tools": (context) => ToolsView(),
  "/settings": (context) => SettingsView(),
  "/drList": (context) => DailyReflectionsView(),
};

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Bloc>(
      builder: (_) => Bloc(
            ThemeData.dark(),
            Locale("en"),
          ),
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localeResolutionCallback = (deviceLocale, supportedLocales) {
      // Check userPreferences (if it exists) for language here.
      if (supportedLocales.contains(deviceLocale)) {
        return Provider.of<Bloc>(context).getLocale;
      }
      return Locale("en");
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Bloc>(context).getTheme,
      locale: Provider.of<Bloc>(context).getLocale,
      localizationsDelegates: localeDelegates,
      supportedLocales: supportedLocales,
      localeResolutionCallback: localeResolutionCallback,
      initialRoute: "/",
      routes: routes,
    );
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tabs = <Widget>[
      Tab(
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(Icons.home),
            Spacer(),
            Text(trans(context, "tab_title_home"))
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(Icons.build),
            Spacer(),
            Text(trans(context, "tab_title_tools"))
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(Icons.settings),
            Spacer(),
            Text(trans(context, "tab_title_settings"))
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: SafeArea(
            minimum: EdgeInsets.only(top: 55),
            child: TabBar(
              indicatorWeight: 6.0,
              indicatorColor: Colors.red,
              tabs: tabs,
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomeView(),
            ToolsView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}
