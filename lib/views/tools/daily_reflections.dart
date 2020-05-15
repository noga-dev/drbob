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
        color: Theme.of(context).textTheme.bodyText1.color,
        decoration: null);
    negRes = TextStyle(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).textTheme.bodyText1.color,
        decoration: null);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _fontSize =
        Provider.of<Bloc>(context).getPrefs.containsKey('fontSize')
            ? Provider.of<Bloc>(context).getPrefs.getDouble('fontSize')
            : 12;
    negRes = negRes.copyWith(fontSize: _fontSize);
    posRes = posRes.copyWith(fontSize: _fontSize);
    return FutureBuilder<dynamic>(
      future: rootBundle.loadString(
          'assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> future) {
        if (future.hasData) {
          drList = DailyReflection.fromJson2List(future.data.toString());
          List<DailyReflection> result = drList;
          if (month != 0)
            result =
                drList.where((DailyReflection x) => x.month == month).toList();
          if (day != 0)
            result = result.where((DailyReflection x) => x.day == day).toList();
          if (search != null)
            result = result
                .where((DailyReflection x) =>
                    (x.excerpt.toLowerCase()).contains(search.toLowerCase()) ||
                    (x.source.toLowerCase()).contains(search.toLowerCase()) ||
                    (x.reflection.toLowerCase()).contains(search.toLowerCase()))
                .toList();
          numberOfResults = trans(context, 'number_of_results_colon') +
              result.length.toString();
          final List<PopupMenuItem<dynamic>> monthsList =
              List<PopupMenuItem<dynamic>>.generate(
            13,
            (int f) => PopupMenuItem<dynamic>(
              child: Center(
                child: Text(
                  (f == 0) ? trans(context, 'month') : f.toString(),
                ),
              ),
              value: f,
            ),
          );
          return MyScaffold(
            implyLeading: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: TextField(
                    textAlign: TextAlign.center,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: trans(
                        context,
                        'search',
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      counter: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          numberOfResults ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            height: .5,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isDense: true,
                    ),
                    onChanged: (String t) => setState(() => search = t),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(.5),
                    onTap: () => null,
                    child: PopupMenuButton<dynamic>(
                      offset: const Offset(0, 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            month > 0
                                ? month.toString()
                                : trans(
                                    context,
                                    'month',
                                  ),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ],
                      ),
                      initialValue: month,
                      onSelected: (dynamic val) {
                        setState(
                          () {
                            day = 0;
                            month = int.tryParse(
                              val.toString(),
                            );
                          },
                        );
                      },
                      itemBuilder: (BuildContext context) => monthsList,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () => null,
                    child: PopupMenuButton<int>(
                      offset: const Offset(0, 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (month > 0)
                            Text(
                              day > 0
                                  ? day.toString()
                                  : trans(
                                      context,
                                      'day',
                                    ),
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              ),
                            )
                          else
                            Text(
                              trans(context, 'day'),
                              style: TextStyle(
                                color: Provider.of<Bloc>(context)
                                    .getTheme
                                    .disabledColor,
                              ),
                            ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: month > 0
                                ? Theme.of(context).textTheme.bodyText1.color
                                : Theme.of(context).disabledColor,
                          )
                        ],
                      ),
                      enabled: month > 0,
                      initialValue: day,
                      itemBuilder: (BuildContext context) => (drList
                              .where((DailyReflection x) =>
                                  (month != 0) ? x.month == month : null)
                              .isNotEmpty)
                          ? (drList
                              .where((DailyReflection x) =>
                                  (month != 0) ? x.month == month : null)
                              .map(
                                (DailyReflection f) => PopupMenuItem<int>(
                                  child: Center(
                                    child: Text(
                                      f.day.toString(),
                                    ),
                                  ),
                                  value: f.day,
                                  key: Key(
                                    f.day.toString(),
                                  ),
                                ),
                              )
                              .toList()
                                ..insert(
                                  0,
                                  PopupMenuItem<int>(
                                    child: Center(
                                      child: Text(
                                        trans(
                                          context,
                                          'day',
                                        ),
                                      ),
                                    ),
                                    value: 0,
                                    key: const Key('0'),
                                  ),
                                ))
                          : null,
                      onSelected: (int val) => setState(() => day = val),
                    ),
                  ),
                ),
              ],
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: (result.isNotEmpty)
                        // ExcludeSemantics is a workaround for this bug: https://github.com/flutter/flutter/issues/30675 which causes the app to crash
                        ? ExcludeSemantics(
                            child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                thickness: 5,
                              ),
                              itemCount: result.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  result
                                      .map(
                                        (DailyReflection f) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 6,
                                          ),
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        DailyReflectionView(
                                                  month: f.month,
                                                  day: f.day,
                                                ),
                                              ),
                                            ),
                                            enableFeedback: true,
                                            splashColor: Colors
                                                .primaries[Random().nextInt(
                                                    Colors.primaries.length)]
                                                .withOpacity(.5),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    RichText(
                                                      text: searchMatch(
                                                        f.title,
                                                      ),
                                                    ),
                                                    const Text(
                                                      '\n',
                                                      style: TextStyle(
                                                          height: .25),
                                                    ),
                                                    Text(
                                                      intl.DateFormat.MMMd(
                                                        Localizations.localeOf(
                                                                context)
                                                            .languageCode,
                                                      )
                                                          .format(
                                                            DateTime.parse(
                                                              '2016' +
                                                                  ((f.month <
                                                                          10)
                                                                      ? '-0' +
                                                                          f.month
                                                                              .toString()
                                                                      : '-' +
                                                                          f.month
                                                                              .toString()) +
                                                                  ((f.day < 10)
                                                                      ? '-0' +
                                                                          f.day
                                                                              .toString()
                                                                      : '-' +
                                                                          f.day
                                                                              .toString()) +
                                                                  ' 00:00:00.000000',
                                                            ),
                                                          )
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: _fontSize),
                                                      textScaleFactor: .75,
                                                    ),
                                                    const Text(
                                                      '\n',
                                                      textScaleFactor: .25,
                                                    ),
                                                    RichText(
                                                      text: searchMatch(
                                                        f.excerpt,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                    const Text(
                                                      '\n',
                                                      textScaleFactor: .25,
                                                    ),
                                                    RichText(
                                                      text: searchMatch(
                                                        f.source,
                                                      ),
                                                      textScaleFactor: .75,
                                                    ),
                                                    const Text(
                                                      '\n',
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
                                      .toList()[index],
                            ),
                          )
                        : Center(
                            child: Text(
                              trans(context, 'no_results'),
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
            child: const CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ),
          );
        }
      },
    );
  }

  // NOTE (AN) Convert to stream/future?
  TextSpan searchMatch(String match) {
    if (search == null || search == '')
      return TextSpan(text: match, style: negRes);
    final String refinedMatch = match.toLowerCase();
    final String refinedSearch = search.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: posRes,
          text: match.substring(0, refinedSearch.length),
          children: <TextSpan>[
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
          children: <TextSpan>[
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
      children: <TextSpan>[
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }
}
