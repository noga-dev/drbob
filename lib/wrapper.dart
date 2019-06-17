import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/Bloc.dart';
import 'utils/localization.dart';
import 'views/home.dart';
import 'views/home/daily_reflection.dart';

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
      home: AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
  final list = [
    DropdownMenuItem(
      child: Center(child: Text("English")),
      key: Key("English"),
      value: "en",
    ),
    DropdownMenuItem(
      child: Center(child: Text("Русский")),
      key: Key("Русский"),
      value: "ru",
    ),
    DropdownMenuItem(
      child: Center(child: Text("עברית")),
      key: Key("עברית"),
      value: "he",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: HomeView(),
        drawerScrimColor: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.grey.withOpacity(.5)
            : Colors.pink.withOpacity(.5),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: Theme(
            data: Theme.of(context),
            child: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(.75)),
                    child: Container(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: FlatButton.icon(
                          label: Text(
                          trans(context, "Dr. Bob"),
                        ),
                        icon: Icon(Icons.hearing),
                        onPressed: () => null,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        buildSobrietyDate(context),
                        buildLanguage(context),
                        buildAbout(context),
                      ],
                    ),
                  ),
                  buildBrightness(context),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: buildTodaysReflectionFAP(context),
      ),
    );
  }

  Widget buildAbout(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () => null,
        child: Tooltip(
          message: trans(context, "desc_about"),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(Icons.help_outline),
              ),
              Text(
                trans(context, "btn_about"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSobrietyDate(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (c, f) {
          return StatefulBuilder(
            builder: (c, s) {
              if (f.connectionState == ConnectionState.done) {
                var sobDate = ((f.data as SharedPreferences)
                        .containsKey("sobrietyDateInt"))
                    ? DateTime.fromMillisecondsSinceEpoch(
                        (f.data as SharedPreferences).getInt("sobrietyDateInt"))
                    : DateTime.now();
                return InkWell(
                  child: Tooltip(
                    preferBelow: false,
                    message: trans(c, "settings_date_format"),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Text(
                          "${sobDate.day}.${sobDate.month}.${sobDate.year}",
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      context: c,
                      initialDate: sobDate,
                      lastDate: DateTime.now(),
                    ).then((val) {
                      s(() {
                        (f.data as SharedPreferences).setInt(
                            "sobrietyDateInt", val.millisecondsSinceEpoch);
                      });
                    });
                  },
                  splashColor: Colors.blue,
                );
              } else {
                return RefreshProgressIndicator(
                  backgroundColor: Colors.orange,
                  strokeWidth: 5,
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildLanguage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: Tooltip(
        preferBelow: false,
        message: trans(context, "pick_language"),
        child: InkWell(
          splashColor: Colors.pink,
          child: DropdownButton(
            isExpanded: true,
            underline: Container(),
            icon: Container(),
            hint: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.translate),
                Text(
                  list
                      .firstWhere((x) =>
                          x.value ==
                          Localizations.localeOf(context).languageCode)
                      .key
                      .toString()
                      .replaceAll("[<'", "")
                      .replaceAll("'>]", ""),
                  style:
                      TextStyle(color: Theme.of(context).textTheme.body1.color),
                ),
              ],
            ),
            items: list,
            onChanged: (v) =>
                Provider.of<Bloc>(context).changeLocale(Locale(v)),
          ),
          onTap: () => null,
        ),
      ),
    );
  }

  Widget buildBrightness(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: Tooltip(
        preferBelow: false,
        message: trans(context, "change_theme"),
        child: InkWell(
          onTap: () => null,
          splashColor: Colors.red,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.vertical(top: Radius.circular(120.0)),
              //   gradient: (Theme.of(context).brightness == Brightness.dark)
              //       ? LinearGradient(
              //           begin: Alignment(-1, -30),
              //           end: Alignment(1, 30),
              //           stops: [.5, .5],
              //           colors: [Colors.black.withOpacity(0), Colors.white70],
              //         )
              //       : LinearGradient(
              //           begin: Alignment(-1, -30),
              //           end: Alignment(1, 30),
              //           stops: [.5, .5],
              //           colors: [Colors.white, Colors.black54],
              //         ),
              // ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.brightness_7,
                            color: Colors.amber[800],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Switch(
                      value: (Theme.of(context).brightness == Brightness.dark)
                          ? true
                          : false,
                      inactiveTrackColor: Colors.grey.withOpacity(.75),
                      activeTrackColor: Colors.grey.withOpacity(.75),
                      inactiveThumbColor: Colors.amber,
                      activeColor: Colors.lightBlue,
                      onChanged: (val) {
                        var theme =
                            (Theme.of(context).brightness == Brightness.light)
                                ? Brightness.dark
                                : Brightness.light;
                        Provider.of<Bloc>(context).changeTheme(
                          ThemeData(
                            brightness: theme,
                            primaryColor: Provider.of<Bloc>(context)
                                .getTheme
                                .primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.brightness_3,
                            color: Colors.lightBlue[800],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildTodaysReflectionFAP(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyReflectionView(),
            ),
          ),
      label: Text(
        trans(context, "btn_todays_reflection"),
        style: TextStyle(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Colors.black
                : Colors.white),
      ),
      backgroundColor: Colors.lightBlue,
    );
  }
}
