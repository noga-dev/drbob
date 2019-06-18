import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';

import 'tools/daily_reflections.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.25),
          child: Center(
            child: Column(
              children: <Widget>[
                buildRaisedButton(context),
                RaisedButton(
                  color: Colors.pink,
                  child: Text(
                    trans(context, "btn_daily_reflections"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyReflectionsListView()),
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  RaisedButton buildRaisedButton(BuildContext context) {
    return RaisedButton(
      color: Colors.purple,
      child: Text(
        trans(context, "btn_serenity_prayer"),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (c) {
            return BottomSheet(
              onClosing: () => null,
              builder: (c) {
                return Container(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    trans(c, "serenity_prayer"),
                    style: TextStyle(fontSize: 22),
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
