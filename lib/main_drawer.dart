import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
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

  final horizItemInset = 50.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .75,
        child: Theme(
          data: Theme.of(context),
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onLongPress: () => null,
                  splashColor: Colors.yellow,
                  child: Tooltip(
                    message: trans(context, "disabled_func"),
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.teal),
                      child: Container(
                        child: Center(
                          child: Text(
                            trans(context, "Dr. Bob"),
                            textScaleFactor: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
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
    );
  }

  Widget buildAbout(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () => null,
        child: Tooltip(
          message: trans(context, "disabled_func"),
          preferBelow: false,
          verticalOffset: 40,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizItemInset),
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
      ),
    );
  }

  Widget buildSobrietyDate(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: StatefulBuilder(
        builder: (c, s) {
          var prefs = Provider.of<Bloc>(context).getPrefs;
          var sobDate = (prefs.containsKey("sobrietyDateInt"))
              ? DateTime.fromMillisecondsSinceEpoch(
                  prefs.getInt("sobrietyDateInt"))
              : DateTime.now();
          return InkWell(
            child: Tooltip(
              preferBelow: false,
              message: trans(c, "settings_date_format"),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: horizItemInset),
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
            ),
            onTap: () {
              showDatePicker(
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                context: c,
                initialDate: sobDate,
                lastDate: DateTime.now(),
              ).then((val) {
                s(() {
                  if (val != null) {
                    prefs.setInt("sobrietyDateInt", val.millisecondsSinceEpoch);
                    Provider.of<Bloc>(context).notify();
                  }
                });
              });
            },
            splashColor: Colors.blue,
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizItemInset),
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
                      style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color,
                        fontSize: Theme.of(context).textTheme.body1.fontSize
                      ),
                    ),
                  ],
                ),
                items: list,
                onChanged: (String v) {
                  if (Localizations.localeOf(context).languageCode == v) return;
                  Provider.of<Bloc>(context).changeLocale(Locale(v));
                }),
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
}
