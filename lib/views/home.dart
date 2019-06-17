import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';

import 'tools/daily_reflections.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            ],
          ),
        ),
        buildRaisedButton(context),
        RaisedButton(
            child: Text(trans(context, "btn_daily_reflections")),
            onPressed: () async => await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyReflectionsListView()),
                ),
          ),
      ],
    );
  }

  RaisedButton buildRaisedButton(BuildContext context) {
    return RaisedButton(
      child: Text(trans(context, "btn_serenity_prayer")),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (c) {
            return BottomSheet(
              onClosing: () => null,
              builder: (c) {
                return Container(
                  padding: EdgeInsets.all(MediaQuery.of(c).size.width * .2),
                  child: Text(
                    trans(c, "serenity_prayer"),
                    style: TextStyle(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
