import 'dart:math';

import 'package:drbob/blocs/bloc.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/daily_reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class DailyReflectionsListView extends StatefulWidget {
  const DailyReflectionsListView({super.key});

  @override
  _DailyReflectionsListViewState createState() =>
      _DailyReflectionsListViewState();
}

class _DailyReflectionsListViewState extends State<DailyReflectionsListView> {
  List<DailyReflection> drList = const <DailyReflection>[];
  String search = '';
  String? numberOfResults;
  int month = 0, day = 0;
  TextStyle? negRes, posRes;
  String? refinedMatch, refinedSearch;

  @override
  void didChangeDependencies() {
    posRes = TextStyle(
        backgroundColor: Colors.red,
        color: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: null);
    negRes = TextStyle(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: null);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double? fontSize =
        Provider.of<Bloc>(context).getPrefs.containsKey('fontSize')
            ? Provider.of<Bloc>(context).getPrefs.getDouble('fontSize')
            : 12;
    negRes = negRes?.copyWith(fontSize: fontSize);
    posRes = posRes?.copyWith(fontSize: fontSize);
    return FutureBuilder<dynamic>(
      future: rootBundle.loadString(
          'assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> future) {
        if (future.hasData) {
          drList = DailyReflection.fromJson2List(future.data.toString());
          List<DailyReflection> result = drList;
          if (month != 0) {
            result =
                drList.where((DailyReflection x) => x.month == month).toList();
          }
          if (day != 0) {
            result = result.where((DailyReflection x) => x.day == day).toList();
          }
          result = result
              .where((DailyReflection x) =>
                  x.excerpt.toLowerCase().contains(search.toLowerCase()) ||
                  x.source.toLowerCase().contains(search.toLowerCase()) ||
                  x.reflection.toLowerCase().contains(search.toLowerCase()))
              .toList();
          numberOfResults = trans(context, 'number_of_results_colon') +
              result.length.toString();
          final List<PopupMenuItem<dynamic>> monthsList =
              List<PopupMenuItem<dynamic>>.generate(
            13,
            (int f) => PopupMenuItem<dynamic>(
              value: f,
              child: Center(
                child: Text(
                  (f == 0) ? trans(context, 'month') : f.toString(),
                ),
              ),
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
                    onTap: () {},
                    child: PopupMenuButton<dynamic>(
                      offset: const Offset(0, 100),
                      initialValue: month,
                      onSelected: (dynamic val) {
                        setState(
                          () {
                            day = 0;
                            month = int.tryParse(
                                  val.toString(),
                                ) ??
                                0;
                          },
                        );
                      },
                      itemBuilder: (BuildContext context) => monthsList,
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
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {},
                    child: PopupMenuButton<int>(
                      offset: const Offset(0, 100),
                      enabled: month > 0,
                      initialValue: day,
                      itemBuilder: (BuildContext context) => (drList
                              .where((DailyReflection x) => x.month == month)
                              .isNotEmpty)
                          ? (drList
                              .where((DailyReflection x) => x.month == month)
                              .map(
                                (DailyReflection f) => PopupMenuItem<int>(
                                  value: f.day,
                                  key: Key(
                                    f.day.toString(),
                                  ),
                                  child: Center(
                                    child: Text(
                                      f.day.toString(),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                            ..insert(
                              0,
                              PopupMenuItem<int>(
                                value: 0,
                                key: const Key('0'),
                                child: Center(
                                  child: Text(
                                    trans(
                                      context,
                                      'day',
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          : <PopupMenuItem<int>>[],
                      onSelected: (int val) => setState(() => day = val),
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
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
                                ? Theme.of(context).textTheme.bodyLarge!.color
                                : Theme.of(context).disabledColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                                              builder: (BuildContext context) =>
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
                                                            '2016${(f.month < 10) ? '-0${f.month}' : '-${f.month}'}${(f.day < 10) ? '-0${f.day}' : '-${f.day}'} 00:00:00.000000',
                                                          ),
                                                        )
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: fontSize),
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            0.75),
                                                  ),
                                                  const Text(
                                                    '\n',
                                                    textScaler:
                                                        TextScaler.linear(0.25),
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
                                                    textScaler:
                                                        TextScaler.linear(0.25),
                                                  ),
                                                  RichText(
                                                    text: searchMatch(
                                                      f.source,
                                                    ),
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            .75),
                                                  ),
                                                  const Text(
                                                    '\n',
                                                    textScaler:
                                                        TextScaler.linear(0.25),
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
          );
        } else if (future.hasError) {
          return ErrorWidget(future.data);
        } else {
          return const CircularProgressIndicator(
            backgroundColor: Colors.pink,
          );
        }
      },
    );
  }

  // NOTE (AN) Convert to stream/future?
  TextSpan searchMatch(String match) {
    if (search == '') {
      return TextSpan(text: match, style: negRes);
    }

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
