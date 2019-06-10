import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/models/daily_reflection.dart';
import 'package:aadr/views/home/daily_reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: <Widget>[
          buildColumn(context),
          FlatButton(child: Text("new"),onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DailyReflectionView()));
          },),
        ],),
      ),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
        children: <Widget>[
          Center(
            child: Card(
              child: RaisedButton(
                child: Text("test"),
                onPressed: () {
                  FutureBuilder(
                    future: rootBundle.loadString(
                        "assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json"),
                    builder: (_, s) {
                      if (s.hasData) {
                        return Text(
                            (DailyReflection.fromJson2List(s.data.toString())
                                    as List<DailyReflection>)
                                .firstWhere((x) =>
                                    x.day == DateTime.now().day &&
                                    x.month == DateTime.now().month)
                                .reflection);
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
  }
}
