import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/daily_reflection.dart';
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
  String numberOfResults;
  int month = 0, day = 0;

  TextStyle negRes, posRes;
  String refinedMatch, refinedSearch;

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    posRes = TextStyle(
        backgroundColor: Colors.red,
        color: Theme.of(context).textTheme.body1.color,
        decoration: null);
    negRes = TextStyle(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).textTheme.body1.color,
        decoration: null);
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
  }

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
          numberOfResults =
              trans(context, "number_of_results_colon") + res.length.toString();
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: trans(context, "search"),
                      contentPadding: EdgeInsets.all(2.0),
                      hintStyle: TextStyle(color: Colors.grey),
                      counter: Align(
                        alignment: Alignment.centerRight,
                        heightFactor: 1.5,
                        child: Text(
                          numberOfResults ?? "",
                          style: TextStyle(fontSize: 14, height: .5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isDense: true,
                    ),
                    onChanged: (t) {
                      setState(() => search = t);
                    },
                  ),
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
                  color: (month == 0) ? Colors.transparent : Colors.blueGrey,
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
                                                  Colors.blue.withOpacity(.5),
                                              child: Card(
                                                elevation: 0,
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.green),
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

  // NOTE (AN) Convert to stream/future?
  TextSpan searchMatch(String match) {
    if (search == null || search == "") return TextSpan(text: match, style: negRes);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = search.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: posRes,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: posRes);
      } else {
        return TextSpan(
          style: negRes,
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
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: negRes);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: negRes,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }
}
