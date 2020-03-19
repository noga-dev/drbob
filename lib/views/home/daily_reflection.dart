import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class DailyReflectionView extends StatelessWidget {
  const DailyReflectionView({this.month, this.day});

  final int day, month;

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
        future: rootBundle.loadString(
            'assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json'),
        builder: (BuildContext _, AsyncSnapshot<dynamic> s) {
          if (s.hasData) {
            final DailyReflection dr =
                DailyReflection.fromJson2List(s.data.toString()).firstWhere(
                    (DailyReflection x) => x.day == day && x.month == month);
            final List<DailyReflection> total =
                DailyReflection.fromJson2List(s.data.toString());

            int nextMonth, nextDay, prevMonth, prevDay;

            if (total.where((DailyReflection x) => x.month == dr.month).length >
                dr.day) {
              nextMonth = dr.month;
              nextDay = dr.day + 1;
            } else if (dr.month == 12 && dr.day == 31) {
              nextMonth = 1;
              nextDay = 1;
            } else {
              nextMonth = dr.month + 1;
              nextDay = 1;
            }

            if (dr.month >= 1 && dr.day > 1) {
              prevMonth = dr.month;
              prevDay = dr.day - 1;
            } else if (month > 1 && day == 1) {
              prevMonth = dr.month - 1;
              prevDay = total
                  .where((DailyReflection x) => x.month == dr.month - 1)
                  .length;
            } else {
              prevMonth = 12;
              prevDay = 31;
            }

            return MyScaffold(
              implyLeading: true,
              title: Center(
                child: Text(
                  dr.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              child: Dismissible(
                key: UniqueKey(),
                resizeDuration: null,
                direction: DismissDirection.horizontal,
                background: DailyReflectionView(
                  month: prevMonth,
                  day: prevDay,
                ),
                secondaryBackground: DailyReflectionView(
                  month: nextMonth,
                  day: nextDay,
                ),
                onDismissed: (DismissDirection d) {
                  //ignore: implicit_dynamic_method
                  Navigator.pushReplacement(
                    context,
                    //ignore: implicit_dynamic_type
                    MaterialPageRoute<void>(
                      builder: (dynamic context) =>
                          d == DismissDirection.startToEnd
                              ? DailyReflectionView(
                                  day: prevDay,
                                  month: prevMonth,
                                )
                              : DailyReflectionView(
                                  day: nextDay,
                                  month: nextMonth,
                                ),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          intl.DateFormat.MMMMd(
                                                      Localizations.localeOf(
                                                              context)
                                                          .languageCode)
                                                  .format(
                                                DateTime.parse(DateTime.now()
                                                        .year
                                                        .toString() +
                                                    ((month < 10)
                                                        ? '-0'
                                                        : '-') +
                                                    month.toString() +
                                                    ((day < 10) ? '-0' : '-') +
                                                    day.toString() +
                                                    ' 00:00:00.000000'),
                                              ) +
                                              '\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  Provider.of<Bloc>(context)
                                                          .getFontSize -
                                                      2),
                                        ),
                                        SelectableText(
                                          dr.excerpt,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize:
                                                  Provider.of<Bloc>(context)
                                                      .getFontSize,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SelectableText(
                                          '\n' + dr.source,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  Provider.of<Bloc>(context)
                                                          .getFontSize -
                                                      2,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: SelectableText(
                                  dr.reflection,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: Provider.of<Bloc>(context)
                                          .getFontSize),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
}
