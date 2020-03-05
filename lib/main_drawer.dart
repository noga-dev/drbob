import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool notifExpanded = false;
  bool langExpanded = false;
  // final _languages = [
  //   DropdownMenuItem(
  //     child: Center(child: Text("English")),
  //     key: Key("English"),
  //     value: "en",
  //   ),
  //   DropdownMenuItem(
  //     child: Center(child: Text("Русский")),
  //     key: Key("Русский"),
  //     value: "ru",
  //   ),
  //   DropdownMenuItem(
  //     child: Center(child: Text("עברית")),
  //     key: Key("עברית"),
  //     value: "he",
  //   ),
  // ];
  final _languages = [
    MapEntry("en", "English"),
    MapEntry("he", "עברית"),
    MapEntry("ru", "Русский"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
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
                            trans(context, "title_drawer"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                          ),
                        ),
                        buildSobrietyDate(context),
                        Divider(),
                        buildLanguage(context),
                        Divider(),
                        buildNotifications(context),
                        Divider(),
                        buildAbout(context),
                      ],
                    ),
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

  Widget buildNotifications(BuildContext context) {
    bool notifActive =
        Provider.of<Bloc>(context).getPrefs.getBool("notifActive") ?? false;
    return Container(
      child: InkWell(
        splashColor: Colors.green,
        onTap: () => null,
        child: Tooltip(
          message: trans(context, "notification_tooltip"),
          preferBelow: false,
          verticalOffset: 40,
          child: Container(
            child: ExpansionTile(
              title: Text(
                trans(context, "btn_notifications"),
              ),
              trailing: Directionality(
                textDirection: TextDirection.ltr,
                child: notifActive
                    ? Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).accentColor,
                      )
                    : Icon(Icons.notifications_off),
              ),
              onExpansionChanged: (_) =>
                  setState(() => notifExpanded = !notifExpanded),
              leading: Icon(
                notifExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(trans(context,
                          notifActive ? "notif_enabled" : "notif_disabled")),
                      Container(
                        width: 85,
                        child: Switch(
                          value: notifActive,
                          onChanged: (bool v) {
                            Provider.of<Bloc>(context)
                                .getPrefs
                                .setBool("notifActive", v);
                            setState(() => null);
                            if (v) {
                              updateNotif(context);
                            } else {
                              Provider.of<Bloc>(context).flnp.cancel(0);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  enabled: notifActive,
                  title: Text(trans(context, "time")),
                  trailing: MaterialButton(
                    onPressed: notifActive
                        ? () => showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: Provider.of<Bloc>(context)
                                        .getPrefs
                                        .getInt("notifHour") ??
                                    8,
                                minute: Provider.of<Bloc>(context)
                                        .getPrefs
                                        .getInt("notifMin") ??
                                    0,
                              ),
                            ).then((TimeOfDay val) {
                              if (val != null) {
                                Provider.of<Bloc>(context).getPrefs.setInt(
                                      "notifHour",
                                      val.hour,
                                    );
                                Provider.of<Bloc>(context).getPrefs.setInt(
                                      "notifMin",
                                      val.minute,
                                    );
                                updateNotif(context);
                                setState(() => null);
                              }
                            })
                        : null,
                    child: Text(
                      TimeOfDay(
                              hour: Provider.of<Bloc>(context)
                                      .getPrefs
                                      .getInt("notifHour") ??
                                  8,
                              minute: Provider.of<Bloc>(context)
                                      .getPrefs
                                      .getInt("notifMin") ??
                                  0)
                          .format(context),
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateNotif(BuildContext context) {
    Provider.of<Bloc>(context).flnp.showDailyAtTime(
          0,
          trans(context, "notif_dr_title"),
          trans(context, "notif_dr_desc"),
          Time(Provider.of<Bloc>(context).getPrefs.getInt("notifHour") ?? 8,
              Provider.of<Bloc>(context).getPrefs.getInt("notifMin") ?? 0, 00),
          NotificationDetails(
            AndroidNotificationDetails(
              "0",
              "Dr. Bob",
              "Daily Reflection",
              importance: Importance.Max,
              priority: Priority.Max,
            ),
            IOSNotificationDetails(),
          ),
        );
  }

  Widget buildAbout(BuildContext context) {
    return Container(
      child: InkWell(
        splashColor: Colors.green,
        onTap: () => null,
        child: Tooltip(
          message: trans(context, "disabled_func"),
          preferBelow: false,
          verticalOffset: 40,
          child: Container(
            child: ListTile(
              title: Text(
                trans(context, "btn_about"),
              ),
              leading: Icon(
                Icons.navigate_next,
                color: Colors.transparent,
              ),
              trailing: Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(Icons.help_outline),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSobrietyDate(BuildContext context) {
    var prefs = Provider.of<Bloc>(context).getPrefs;
    var now = DateTime.now();
    var sobDate = (prefs.containsKey("sobrietyDateInt"))
        ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt("sobrietyDateInt"))
        : now;
    return Container(
      child: InkWell(
        child: Tooltip(
          preferBelow: false,
          message: trans(context, "settings_date_format"),
          child: ListTile(
            title: Text(
              sobDate == now ? trans(context, "set_sobriety_date") : "${sobDate.day}.${sobDate.month}.${sobDate.year}"
            ),
            leading: Icon(Icons.ac_unit, color: Colors.transparent),
            trailing: Icon(Icons.calendar_today),
          ),
        ),
        onTap: () {
          showDatePicker(
            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
            context: context,
            initialDate: sobDate,
            lastDate: DateTime.now(),
          ).then((val) {
            setState(() {
              if (val != null) {
                prefs.setInt("sobrietyDateInt", val.millisecondsSinceEpoch);
                Provider.of<Bloc>(context).notify();
              }
            });
          });
        },
        splashColor: Colors.blue,
      ),
    );
  }

  Widget buildLanguage(BuildContext context) {
    return Container(
      child: Tooltip(
        preferBelow: false,
        message: trans(context, "pick_language"),
        child: InkWell(
          splashColor: Colors.pink,
          child: Container(
            child: ExpansionTile(
              title: Text(
                _languages
                    .firstWhere((x) =>
                        x.key == Localizations.localeOf(context).languageCode)
                    .value,
              ),
              leading: Icon(
                langExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              trailing: Icon(Icons.translate),
              onExpansionChanged: (_) =>
                  setState(() => langExpanded = !langExpanded),
              children: _languages
                  .map((f) => RadioListTile(
                        value: f.key,
                        groupValue:
                            Localizations.localeOf(context).languageCode,
                        title: Text(f.value),
                        onChanged: (v) {
                          if (Localizations.localeOf(context).languageCode == v)
                            return;
                          Provider.of<Bloc>(context).changeLocale(Locale(v));
                        },
                      ))
                  .toList(),
            ),
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
