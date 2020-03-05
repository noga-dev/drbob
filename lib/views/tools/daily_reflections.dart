import 'dart:math';
import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/daily_reflection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class DailyReflectionsListView extends StatefulWidget {
  @override
  _DailyReflectionsListViewState createState() =>
      _DailyReflectionsListViewState();
}

class _DailyReflectionsListViewState extends State<DailyReflectionsListView> {
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
          var monthsList = List<PopupMenuItem>.generate(
              13,
              (f) => PopupMenuItem(
                    child: Center(
                      child: Text(
                        (f == 0) ? trans(context, "month") : f.toString(),
                      ),
                    ),
                    value: f,
                  ));
          return MyScaffold(
            implyLeading: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: TextField(
                    textAlign: TextAlign.center,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: trans(
                        context,
                        "search",
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      counter: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          numberOfResults ?? "",
                          style: TextStyle(
                              fontSize: 12, height: .5, color: Colors.grey),
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
                Expanded(
                  flex: 5,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(.5),
                    onTap: () => null,
                    child: PopupMenuButton(
                      offset: Offset(0, 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(month > 0
                              ? month.toString()
                              : trans(context, "month")),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      initialValue: month,
                      onSelected: (val) {
                        setState(
                          () {
                            day = 0;
                            month = val;
                          },
                        );
                      },
                      itemBuilder: (context) {
                        return monthsList;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () => null,
                    child: PopupMenuButton(
                      offset: Offset(0, 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          month > 0
                              ? Text(day > 0
                                  ? day.toString()
                                  : trans(context, "day"))
                              : Text(
                                  trans(context, "day"),
                                  style: TextStyle(
                                    color: Provider.of<Bloc>(context)
                                        .getTheme
                                        .disabledColor,
                                  ),
                                ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: month > 0
                                ? null
                                : Theme.of(context).disabledColor,
                          )
                        ],
                      ),
                      enabled: month > 0,
                      initialValue: day,
                      itemBuilder: (context) {
                        return (drList
                                    .where((x) =>
                                        (month != 0) ? x.month == month : false)
                                    .length >
                                0)
                            ? (drList
                                .where((x) =>
                                    (month != 0) ? x.month == month : false)
                                .map(
                                  (f) => PopupMenuItem<int>(
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
                                    PopupMenuItem<int>(
                                      child: Center(
                                        child: Text(trans(context, "day")),
                                      ),
                                      value: 0,
                                      key: Key("0"),
                                    ),
                                  ))
                            : null;
                      },
                      onSelected: (int val) {
                        setState(() {
                          day = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: (res.length > 0)
                        // ExcludeSemantics is a workaround for this bug: https://github.com/flutter/flutter/issues/30675 which causes the app to crash
                        ? ExcludeSemantics(
                            child: ListView(
                              children: res
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
                                        splashColor: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]
                                            .withOpacity(.5),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.green),
                                            ),
                                            padding: EdgeInsets.all(6.0),
                                            child: Column(
                                              children: <Widget>[
                                                RichText(
                                                  text: searchMatch(
                                                    f.title,
                                                  ),
                                                ),
                                                Text(
                                                  "\n",
                                                  style:
                                                      TextStyle(height: .25),
                                                ),
                                                Text(
                                                  intl.DateFormat.MMMd(
                                                    Localizations.localeOf(
                                                            context)
                                                        .languageCode,
                                                  )
                                                      .format(
                                                        DateTime.parse(
                                                          "2016" +
                                                              ((f.month < 10)
                                                                  ? "-0" +
                                                                      f.month
                                                                          .toString()
                                                                  : "-" +
                                                                      f.month
                                                                          .toString()) +
                                                              ((f.day < 10)
                                                                  ? "-0" +
                                                                      f.day
                                                                          .toString()
                                                                  : "-" +
                                                                      f.day
                                                                          .toString()) +
                                                              " 00:00:00.000000",
                                                        ),
                                                      )
                                                      .toString(),
                                                ),
                                                Text(
                                                  "\n",
                                                  textScaleFactor: .25,
                                                ),
                                                RichText(
                                                  text: searchMatch(
                                                    f.excerpt,
                                                  ),
                                                  textAlign:
                                                      TextAlign.justify,
                                                ),
                                                Text(
                                                  "\n",
                                                  textScaleFactor: .25,
                                                ),
                                                RichText(
                                                  text: searchMatch(
                                                    f.source,
                                                  ),
                                                ),
                                                Text(
                                                  "\n",
                                                  textScaleFactor: .25,
                                                ),
                                                RichText(
                                                  text: searchMatch(
                                                      f.reflection),
                                                  textAlign:
                                                      TextAlign.justify,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : Center(
                            child: Text(
                              trans(context, "no_results"),
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
          return Container(
            child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ),
          );
        }
      },
    );
  }

  // NOTE (AN) Convert to stream/future?
  TextSpan searchMatch(String match) {
    if (search == null || search == "")
      return TextSpan(text: match, style: negRes);
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
