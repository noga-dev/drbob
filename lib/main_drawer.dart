import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool isNotifExpanded = false;
  bool isLangExpanded = false;
  bool isFontSizeExpanded = false;
  final List<MapEntry<String, String>> _languages = <MapEntry<String, String>>[
    const MapEntry<String, String>('en', 'English'),
    const MapEntry<String, String>('he', 'עברית'),
    const MapEntry<String, String>('ru', 'Русский'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isNotifActive =
        Provider.of<Bloc>(context).getPrefs.getBool('notifActive') ?? false;
    final SharedPreferences prefs = Provider.of<Bloc>(context).getPrefs;
    final DateTime now = DateTime.now();
    final DateTime sobDate = (prefs.containsKey('sobrietyDateInt'))
        ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt('sobrietyDateInt'))
        : now;

    final List<Widget> items = <Widget>[
      DrawerMenuItem(
        text: 'sobriety_date',
        icon: Icon(Icons.calendar_today),
        sub: Text(
          sobDate == now
              ? trans(context, 'not_set')
              : '${sobDate.day}.${sobDate.month}.${sobDate.year}',
          style: TextStyle(
            color: sobDate == now
                ? Theme.of(context).disabledColor
                : Theme.of(context).accentColor,
          ),
        ),
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                focusElevation: 12,
                elevation: 0,
                color: Colors.transparent,
                onPressed: () => showDatePicker(
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  context: context,
                  initialDate: sobDate,
                  lastDate: DateTime.now(),
                ).then((DateTime val) {
                  setState(() {
                    if (val != null) {
                      prefs.setInt(
                        'sobrietyDateInt',
                        val.millisecondsSinceEpoch,
                      );
                      Provider.of<Bloc>(context).notify();
                    }
                  });
                }),
                child: Text(
                  trans(context, 'change_sobriety_date'),
                ),
              )
            ],
          )
        ],
      ),
      DrawerMenuItem(
        text: 'app_appearance',
        sub: prefs.containsKey('fontSize')
            ? Text(
                prefs.getDouble('fontSize').toInt().toString(),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              )
            : Text(
                trans(context, 'Default'),
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
        icon: Icon(Icons.color_lens),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 22,
                child: const Text(
                  'A',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Slider(
                  onChanged: (double fontSize) => setState(() =>
                      Provider.of<Bloc>(context).changeFontSize(fontSize)),
                  value: Provider.of<Bloc>(context)
                          .getPrefs
                          .containsKey('fontSize')
                      ? Provider.of<Bloc>(context)
                          .getPrefs
                          .getDouble('fontSize')
                      : 12,
                  min: 12,
                  max: 32,
                  divisions: 20,
                ),
              ),
              Container(
                width: 20,
                child: const Text(
                  'A',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.brightness_7,
                color: Colors.amber[800],
              ),
              Expanded(
                child: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  inactiveTrackColor: Colors.grey.withOpacity(.5),
                  activeTrackColor: Colors.grey.withOpacity(.5),
                  inactiveThumbColor: Colors.amber,
                  activeColor: Colors.lightBlue,
                  onChanged: (bool val) =>
                      Provider.of<Bloc>(context).changeTheme(
                    ThemeData(
                      brightness:
                          (Theme.of(context).brightness == Brightness.light)
                              ? Brightness.dark
                              : Brightness.light,
                      primaryColor:
                          Provider.of<Bloc>(context).getTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.brightness_3,
                color: Colors.lightBlue[800],
              ),
            ],
          ),
        ],
      ),
      DrawerMenuItem(
        text: 'app_language',
        sub: Text(
          _languages
              .firstWhere(
                (MapEntry<String, String> x) =>
                    x.key == Localizations.localeOf(context).languageCode,
              )
              .value,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        icon: Icon(Icons.translate),
        children: _languages
            .map(
              (MapEntry<String, String> f) => RadioListTile<String>(
                value: f.key,
                groupValue: Localizations.localeOf(context).languageCode,
                title: Text(f.value),
                onChanged: (String v) {
                  if (Localizations.localeOf(context).languageCode == v) {
                    return;
                  }
                  Provider.of<Bloc>(context).changeLocale(
                    Locale(v),
                  );
                },
              ),
            )
            .toList(),
      ),
      DrawerMenuItem(
        text: 'btn_notifications',
        sub: Text(
          trans(context, isNotifActive ? 'notif_enabled' : 'notif_disabled'),
          style: TextStyle(
            color: isNotifActive
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor,
          ),
        ),
        icon: Icon(
          isNotifActive ? Icons.notifications_active : Icons.notifications_off,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                trans(
                  context,
                  isNotifActive ? 'notif_enabled' : 'notif_disabled',
                ),
              ),
              Container(
                width: 85,
                child: Switch(
                  value: isNotifActive,
                  onChanged: (bool v) {
                    Provider.of<Bloc>(context)
                        .getPrefs
                        .setBool('notifActive', v);
                    setState(() => null);
                    v
                        ? updateNotif(context)
                        : Provider.of<Bloc>(context).flnp.cancel(0);
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                trans(
                  context,
                  'time',
                ),
                style: TextStyle(
                  color: isNotifActive ? null : Theme.of(context).disabledColor,
                ),
              ),
              MaterialButton(
                onPressed: isNotifActive
                    ? () => showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: Provider.of<Bloc>(context)
                                    .getPrefs
                                    .getInt('notifHour') ??
                                8,
                            minute: Provider.of<Bloc>(context)
                                    .getPrefs
                                    .getInt('notifMin') ??
                                0,
                          ),
                        ).then((TimeOfDay val) {
                          if (val != null) {
                            Provider.of<Bloc>(context).getPrefs.setInt(
                                  'notifHour',
                                  val.hour,
                                );
                            Provider.of<Bloc>(context).getPrefs.setInt(
                                  'notifMin',
                                  val.minute,
                                );
                            updateNotif(context);
                          }
                        })
                    : null,
                child: Text(
                  TimeOfDay(
                    hour: Provider.of<Bloc>(context)
                            .getPrefs
                            .getInt('notifHour') ??
                        8,
                    minute: Provider.of<Bloc>(context)
                            .getPrefs
                            .getInt('notifMin') ??
                        0,
                  ).format(context),
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
            ],
          ),
        ],
      ),
      DrawerMenuItem(
        text: 'btn_about',
        sub: Text(
          trans(context, 'dr_bob'),
          style: TextStyle(
            color: Theme.of(context).disabledColor,
          ),
        ),
        icon: Icon(Icons.help_outline),
        children: <Widget>[Text(trans(context, 'disabled_func'))],
      ),
      if (kReleaseMode)
        Container()
      else
        DrawerMenuItem(
          text: 'Debugging',
          icon: Icon(Icons.bug_report),
          children: <Widget>[
            OutlineButton(
              onPressed: () => prefs
                  .clear()
                  .then((bool val) => Provider.of<Bloc>(context).notify()),
              child: const Text('Clear'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('fontSize').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('fontSize'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('sobrietyDateInt').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('sobrietyDateInt'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('notifActive').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('notifActive'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('notifHour').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('notifHour'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('notifMin').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('notifMin'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('theme').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('theme'),
              color: Colors.deepOrange[800],
            ),
            OutlineButton(
              onPressed: () => prefs.remove('lang').then(
                    (bool val) => Provider.of<Bloc>(context).notify(),
                  ),
              child: const Text('lang'),
              color: Colors.deepOrange[800],
            ),
          ],
        ),
    ];

    return Drawer(
      elevation: 0,
      child: Container(
        alignment: Alignment.center,
        color: mainBgColor(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 20,),
          child: Column(
            children: items,
          ),
        ),
      ),
    );
  }

  // TODO(AN): Make notification data show specific information
  void updateNotif(BuildContext context) {
    Provider.of<Bloc>(context).flnp.showDailyAtTime(
          0,
          trans(context, 'notif_dr_title'),
          trans(context, 'notif_dr_desc'),
          Time(Provider.of<Bloc>(context).getPrefs.getInt('notifHour') ?? 8,
              Provider.of<Bloc>(context).getPrefs.getInt('notifMin') ?? 0, 00),
          NotificationDetails(
            AndroidNotificationDetails(
              '0',
              'Dr. Bob',
              'Daily Reflection',
              importance: Importance.Max,
              priority: Priority.Min,
            ),
            IOSNotificationDetails(),
          ),
        );
  }
}

class DrawerMenuItem extends StatefulWidget {
  const DrawerMenuItem({
    @required this.text,
    @required this.icon,
    @required this.children,
    this.sub,
  });

  final String text;
  final Widget sub;
  final Icon icon;
  final List<Widget> children;

  @override
  _DrawerMenuItemState createState() => _DrawerMenuItemState();
}

class _DrawerMenuItemState extends State<DrawerMenuItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        leading: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
        ),
        title: Text(
          trans(context, widget.text),
        ),
        subtitle: widget.sub,
        trailing: Directionality(
          textDirection: TextDirection.ltr,
          child: widget.icon,
        ),
        onExpansionChanged: (_) => setState(() => isExpanded = !isExpanded),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            child: Column(
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
