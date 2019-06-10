import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/utils/localization.dart';
import 'package:aadr/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceView extends StatefulWidget {
  @override
  AppearanceViewState createState() => AppearanceViewState();
}

class AppearanceViewState extends State<AppearanceView> {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<Bloc>(context).getTheme;
    var brightness = theme.brightness;
    var _val = theme.primaryColor.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            buildItem(buildBrightnessItem(brightness, context, theme)),
            buildItem(buildPrimaryColorItem(_val, context, theme)),
          ],
        ),
      ),
    );
  }

  Card buildItem(Widget item) => Card(child: item);

  Widget buildBrightnessItem(
          Brightness brightness, BuildContext context, ThemeData theme) =>
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.white, Colors.black])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Light",
                  style: darkInputText,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Switch(
                value: (brightness == Brightness.dark) ? true : false,
                onChanged: (val) {
                  setState(() {
                    brightness = (brightness == Brightness.light)
                        ? Brightness.dark
                        : Brightness.light;
                    Provider.of<Bloc>(context).changeTheme(
                      ThemeData(
                        brightness: brightness,
                        primaryColor: theme.primaryColor,
                      ),
                    );
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Dark",
                  style: lightInputText,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildPrimaryColorItem(
      int _val, BuildContext context, ThemeData theme) {
    return DropdownButton(
      isExpanded: true,
      underline: Container(),
      hint: Center(
        child: OutlineButton(
          onPressed: () => null,
          borderSide: BorderSide(width: 6.0, color: theme.primaryColor,),
          child: Text(
            trans(context, "theme_primary_color"),
          ),
        ),
      ),
      icon: ClipOval(),
      items: Colors.primaries
          .map(
            (x) => DropdownMenuItem(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Container(
                      color: x,
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: (_val == x.value)
                            ? Text(
                                trans(context, "theme_primary_color"),
                              )
                            : Text(""),
                      ),
                    ),
                  ),
                  value: x.value,
                ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          _val = val;
          Provider.of<Bloc>(context).changeTheme(
            theme.copyWith(
              primaryColor:
                  Colors.primaries.firstWhere((x) => x.value == _val),
            ),
          );
        });
      },
    );
  }
}
