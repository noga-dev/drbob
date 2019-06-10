import 'package:aadr/views/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blocs/Bloc.dart';
import 'utils/localization.dart';
import 'views/home.dart';
import 'views/settings.dart';

var routes = {
  "/": (context) => AppHome(),
  "/home": (context) => HomeView(),
  "/tools": (context) => ToolsView(),
  "/settings": (context) => SettingsView()
};

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Bloc>(
      builder: (_) => Bloc(
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
          Locale("en")),
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
            Icon(Icons.ac_unit),
            Spacer(),
            Text(trans(context, "home_title"))
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(Icons.ac_unit),
            Spacer(),
            Text(trans(context, "home_title"))
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(Icons.ac_unit),
            Spacer(),
            Text(trans(context, "home_title"))
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(trans(context, "home_title")),
          centerTitle: true,
          primary: false,
          flexibleSpace: SafeArea(
            child: TabBar(
              indicatorWeight: 6.0,
              labelPadding: EdgeInsets.symmetric(vertical: 2.0),
              indicatorColor: Colors.red,
              labelColor: Colors.white,
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
