import 'package:aadr/utils/localization.dart';
import 'package:aadr/views/home/daily_reflection.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                elevation: 20.0,
                child: Text(trans(context, "btn_todays_reflection")),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyReflectionView(),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text(trans(context, "btn_todays_prayer")),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (c) {
                      return BottomSheet(
                        onClosing: () => null,
                        builder: (c) {
                          return Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(c).size.width * .2),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
