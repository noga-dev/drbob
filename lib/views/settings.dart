import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/utils/localization.dart';
import 'package:aadr/utils/style.dart';
import 'package:aadr/views/settings/appearance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  Card buildItem(Widget item) => Card(
        child: item,
        elevation: 20.0,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            buildItem(buildAppearanceItem(context)),
            buildItem(buildLanguageItem(context)),
            buildItem(buildSobrietyDateItem(context)),
            buildItem(buildAboutItem(context)),
            buildItem(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: ListTile(
                  title: Center(
                    child: Text("test"),
                  ),
                  leading: Icon(Icons.ac_unit),
                  trailing: Text("Desc"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineButton buildAboutItem(BuildContext context) {
    return OutlineButton(
      onPressed: () => null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.question_answer),
          Text(trans(context, "About"))
        ],
      ),
    );
  }

  FlatButton buildSobrietyDateItem(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.date_range),
          Text(
            trans(context, "home_title"),
          ),
        ],
      ),
      onPressed: () {
        showDatePicker(
          firstDate: DateTime(1900),
          context: context,
          initialDate: DateTime.now(),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  DropdownButton<String> buildLanguageItem(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      isExpanded: true,
      icon: Container(),
      hint: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.language,
          ),
          Text(
            trans(context, "test"),
          ),
        ],
      ),
      items: [
        DropdownMenuItem(
          child: Center(child: Text("English")),
          value: "en",
        ),
        DropdownMenuItem(
          child: Center(child: Text("Русский")),
          value: "ru",
        ),
        DropdownMenuItem(
          child: Center(child: Text("עברית")),
          value: "he",
        ),
      ],
      onChanged: (v) => Provider.of<Bloc>(context).changeLocale(Locale(v)),
    );
  }

  FlatButton buildAppearanceItem(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.palette,
          ),
          Text(trans(context, "theme_primary_color"),
              style: (Provider.of<Bloc>(context).getTheme.brightness ==
                      Brightness.dark)
                  ? lightInputText
                  : darkInputText),
        ],
      ),
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppearanceView(),
            ),
          ),
    );
  }
}
