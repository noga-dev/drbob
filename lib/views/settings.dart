import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
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
    TextStyle valueStyle = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.0);
    Brightness brightness = Provider.of<Bloc>(context).getTheme.brightness;
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: false,
            title: Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius:
                  //     BorderRadius.vertical(bottom: Radius.circular(100.0)),
                  gradient: LinearGradient(
                    begin: Alignment(-1, -30),
                    end: Alignment(1, 30),
                    stops: [.5, .5],
                    colors: [Colors.white, Colors.black],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.brightness_5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Switch(
                        value: (brightness == Brightness.dark) ? true : false,
                        inactiveTrackColor: Colors.grey.withOpacity(.75),
                        activeTrackColor: Colors.grey.withOpacity(.75),
                        inactiveThumbColor: Colors.amber,
                        activeColor: Colors.blue,
                        onChanged: (val) {
                          brightness = (brightness == Brightness.light)
                              ? Brightness.dark
                              : Brightness.light;
                          Provider.of<Bloc>(context).changeTheme(
                            ThemeData(
                              brightness: brightness,
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
                            Icon(Icons.brightness_3, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.red,
            child: DropdownButton(
              underline: Container(),
              icon: Container(),
              isExpanded: true,
              hint: ListTile(
                leading: Icon(
                  Icons.translate,
                ),
                title: Text(
                  trans(
                    context,
                    "btn_language",
                  ),
                  style: valueStyle,
                ),
                trailing: Text(
                  list
                      .firstWhere((x) =>
                          x.value ==
                          Provider.of<Bloc>(context).getLocale.languageCode)
                      .key
                      .toString()
                      .replaceAll("[<'", "")
                      .replaceAll("'>]", ""),
                  style: valueStyle,
                ),
              ),
              items: list,
              onChanged: (v) =>
                  Provider.of<Bloc>(context).changeLocale(Locale(v)),
            ),
            onTap: () => null,
          ),
          StatefulBuilder(
            builder: (c, s) {
              return InkWell(
                onTap: () => null,
                splashColor: Colors.blue,
                child: FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (c, f) {
                    if (f.connectionState == ConnectionState.done) {
                      var sobDate = ((f.data as SharedPreferences)
                              .containsKey("sobrietyDateInt"))
                          ? DateTime.fromMillisecondsSinceEpoch(
                              (f.data as SharedPreferences)
                                  .getInt("sobrietyDateInt"))
                          : DateTime.now();
                      return ListTile(
                        leading: Icon(Icons.date_range),
                        title: Text(
                          // FutureBuilder -> SharedPreferences
                          trans(context, "btn_sobriety_date"),
                          style: valueStyle,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${sobDate.day}.${sobDate.month}.${sobDate.year}",
                              style: valueStyle,
                            ),
                            Text(
                              trans(c, "settings_date_format"),
                            ),
                          ],
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
                                  "sobrietyDateInt",
                                  val.millisecondsSinceEpoch);
                            });
                          });
                        },
                      );
                    } else {
                      return LinearProgressIndicator();
                    }
                  },
                ),
              );
            },
          ),
          InkWell(
            splashColor: Colors.green,
            onTap: () => null,
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                trans(context, "btn_about"),
                style: valueStyle,
              ),
              trailing: Text(
                trans(context, "desc_about"),
                style: valueStyle,
              ),
              onTap: () => null,
            ),
          ),
        ],
      ),
    );
  }
}
