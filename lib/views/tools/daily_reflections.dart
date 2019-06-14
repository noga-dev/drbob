import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/models/daily_reflection.dart';
import 'package:aadr/utils/localization.dart';
import 'package:aadr/views/home/daily_reflection.dart';
import 'package:flutter/cupertino.dart';
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
                  ? (x.excerpt.toLowerCase()).contains(search.toLowerCase()) ||
                      (x.source.toLowerCase()).contains(search.toLowerCase()) ||
                      (x.reflection.toLowerCase())
                          .contains(search.toLowerCase())
                  : true));
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: trans(context, "search"),
                    hintStyle: TextStyle(color: Colors.grey),
                    isDense: true,
                  ),
                  autocorrect: true,
                  onChanged: (t) {
                    setState(() => search = t);
                  },
                ),
              ),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  color: Colors.blueGrey,
                  child: Center(
                    child: DropdownButton<int>(
                      value: month,
                      items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                          .map(
                            (f) => DropdownMenuItem(
                                  child: Center(
                                    child: Text(
                                      (f == 0)
                                          ? trans(context, "month")
                                          : f.toString(),
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
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  color: (month == 0) ? Colors.transparent : Colors.lightBlue[600].withOpacity(.5),
                  child: Center(
                    child: DropdownButton(
                      value: day,
                      items: (drList
                                  .where((x) =>
                                      (month != 0) ? x.month == month : false)
                                  .length >
                              0)
                          ? (drList
                              .where((x) =>
                                  (month != 0) ? x.month == month : false)
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
                                      child: Text(trans(context, "day")),
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
                      disabledHint: Text(
                        trans(context, "day"),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
                                              vertical: 2,
                                              horizontal: 6,
                                            ),
                                            child: InkWell(
                                              onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DailyReflectionView(
                                                            month: f.month,
                                                            day: f.day,
                                                          ),
                                                    ),
                                                  ),
                                              enableFeedback: true,
                                              splashColor:
                                                  Colors.red.withOpacity(.25),
                                              child: Card(
                                                elevation: 0,
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 1),
                                                  ),
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      RichText(
                                                        text: searchMatch(
                                                          f.title,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            trans(context,
                                                                    "month_colon") +
                                                                f.month
                                                                    .toString(),
                                                          ),
                                                          Text(
                                                            trans(context,
                                                                    "day_colon") +
                                                                f.day
                                                                    .toString(),
                                                          )
                                                        ],
                                                      ),
                                                      Text("\n"),
                                                      RichText(
                                                        text: searchMatch(
                                                          f.excerpt,
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: searchMatch(
                                                          f.source,
                                                        ),
                                                      ),
                                                      Text("\n"),
                                                      RichText(
                                                        text: searchMatch(
                                                            f.reflection),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    )
                                    .toList()[idx];
                              },
                            )
                          : Center(
                              child: Text(
                                trans(context, "no_results"),
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

  TextSpan searchMatch(String match) {
    if (search == null)
      return TextSpan(
          text: match,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color));
    var refinedMatch = match.toLowerCase();
    var refinedSearch = search.toLowerCase();
    TextStyle style;
    if (search == "" || !refinedMatch.contains(refinedSearch)) {
      style = TextStyle(
          color: Theme.of(context).textTheme.body1.color,
          decoration: TextDecoration.none);
      return TextSpan(text: match, style: style);
    } else if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.length == refinedSearch.length) {
        style = TextStyle(color: Colors.red);
        return TextSpan(text: match, style: style);
      } else if (refinedMatch.substring(0, refinedSearch.length) ==
          refinedSearch) {
        style =
            TextStyle(color: Colors.red, decoration: TextDecoration.underline);
        return TextSpan(
          style: style,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else {
        style = TextStyle(
            color: Theme.of(context).textTheme.body1.color,
            decoration: TextDecoration.none);
        return TextSpan(
          style: style,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    }
    print("test");
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: style,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }
}
