import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/utils/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Card buildItem(Widget item) => Card(
        child: item,
        elevation: 20.0,
      );

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
      padding: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[
          buildItem(
            Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                decoration: BoxDecoration(
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
                        inactiveThumbColor: Colors.black,
                        activeTrackColor: Colors.grey.withOpacity(.75),
                        activeColor: Colors.white,
                        onChanged: (val) {
                          brightness = (brightness == Brightness.light)
                              ? Brightness.dark
                              : Brightness.light;
                          Provider.of<Bloc>(context).changeTheme(
                            ThemeData(
                              brightness: brightness,
                              primaryColor: Provider.of<Bloc>(context).getTheme.primaryColor,
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
          // buildItem(
          //   ListTile(
          //     leading: Icon(
          //       Icons.palette,
          //     ),
          //     title: Text(
          //       trans(context, "btn_appearance"),
          //       style: valueStyle,
          //     ),
          //     trailing: Container(
          //       decoration: BoxDecoration(
          //           border: Border.all(width: 1, color: Colors.black)),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           border: Border.all(width: 1, color: Colors.white),
          //         ),
          //         child: Directionality(
          //           textDirection: TextDirection.ltr,
          //           child: Row(
          //             mainAxisSize: MainAxisSize.min,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Container(
          //                 height: 20,
          //                 width: 20,
          //                 color: Theme.of(context).brightness == Brightness.dark
          //                     ? Colors.black
          //                     : Colors.white,
          //               ),
          //               Container(
          //                 height: 20,
          //                 width: 20,
          //                 color: Theme.of(context).primaryColor,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     onTap: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => AppearanceView(),
          //           ),
          //         ),
          //   ),
          // ),
          buildItem(
            DropdownButton(
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
          ),
          buildItem(
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text(
                trans(context, "btn_sobriety_date"),
                style: valueStyle,
              ),
              trailing: Text(
                DateTime.now().toString().substring(0, 10),
                style: valueStyle,
              ),
              onTap: () {
                showDatePicker(
                  firstDate: DateTime(1900),
                  context: context,
                  initialDate: DateTime.now(),
                  lastDate: DateTime.now(),
                );
              },
            ),
          ),
          buildItem(
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text(
                trans(context, "btn_about"),
                style: valueStyle,
              ),
              trailing: Text(
                trans(context, "desc_about"),
                style: valueStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
