import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/daily_reflection.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(trans(context, "btn_serenity_prayer")),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyReflectionView(),
                    ),
                  ),
        label: Text(
          trans(context, "btn_todays_reflection"),
          style: TextStyle(color: (Theme.of(context).brightness == Brightness.dark) ? Colors.black : Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        // icon: Container(
        //   height: 40,
        //   width: 40,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       // image: AssetImage("assets/images/noun_hands.png"),
        //           image: NetworkImage("https://img.icons8.com/ios/50/000000/pray.png"),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
