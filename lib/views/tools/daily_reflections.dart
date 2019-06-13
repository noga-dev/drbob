import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/models/daily_reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DailyReflectionsView extends StatefulWidget {
  @override
  _DailyReflectionsViewState createState() => _DailyReflectionsViewState();
}

class _DailyReflectionsViewState extends State<DailyReflectionsView> {
  List<DailyReflection> drList;
  String search;

  int month = 0, day = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString(
          "assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json"),
      builder: (context, future) {
        if (future.hasData) {
          drList = (DailyReflection.fromJson2List(future.data.toString())
              as List<DailyReflection>);
          var res = drList.where((x) =>
              ((month != 0) ? x.month == month : true) &&
              ((day != 0) ? x.day == day : true) &&
              ((search != null)
                  ? x.excerpt.contains(search) ||
                      x.source.contains(search) ||
                      x.excerpt.contains(search)
                  : true));
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    isDense: true,
                  ),
                  autocorrect: true,
                  onChanged: (t) {
                    setState(() {
                      search = t;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                Center(
                  child: DropdownButton<int>(
                    value: month,
                    items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        .map(
                          (f) => DropdownMenuItem(
                                child: Center(
                                  child: Text(
                                    (f == 0) ? "Month" : f.toString(),
                                  ),
                                ),
                                value: f,
                                key: Key(f.toString()),
                              ),
                        )
                        .toList(),
                    onChanged: (int val) {
                      setState(
                        () {
                          day = 0;
                          month = val;
                        },
                      );
                    },
                  ),
                ),
                Center(
                  child: DropdownButton(
                    value: day,
                    items: (drList
                                .where((x) =>
                                    (month != 0) ? x.month == month : false)
                                .length >
                            0)
                        ? (drList
                            .where(
                                (x) => (month != 0) ? x.month == month : false)
                            .map(
                              (f) => DropdownMenuItem<int>(
                                    child: Center(
                                      child: Text(f.day.toString()),
                                    ),
                                    value: f.day,
                                    key: Key(f.day.toString()),
                                  ),
                            )
                            .toList()
                              ..insert(
                                0,
                                DropdownMenuItem<int>(
                                  child: Center(
                                    child: Text("Day"),
                                  ),
                                  value: 0,
                                  key: Key("0"),
                                ),
                              ))
                        : null,
                    onChanged: (int val) {
                      setState(() {
                        day = val;
                      });
                    },
                    disabledHint: Text("Day"),
                  ),
                ),
              ],
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Scrollbar(
                      child: (res.length > 0)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: res.length,
                              itemBuilder: (context, idx) {
                                return res
                                    .map(
                                      (f) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 6),
                                            child: Card(
                                              elevation: 6,
                                              child: Column(
                                                children: <Widget>[
                                                  Text("Month: " +
                                                      f.month.toString() +
                                                      ", " +
                                                      "Day: " +
                                                      f.day.toString()),
                                                  Text(f.excerpt),
                                                  Text(f.source),
                                                  Text(f.reflection),
                                                ],
                                              ),
                                            ),
                                          ),
                                    )
                                    .toList()[idx];
                              },
                            )
                          : Center(
                              child: Text(
                                "Nothing",
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (future.hasError) {
          return ErrorWidget(future.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
