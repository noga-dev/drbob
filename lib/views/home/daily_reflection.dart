import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/main_drawer.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class DailyReflectionView extends StatelessWidget {
  final int day, month;

  DailyReflectionView({this.month, this.day});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString(
          "assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json"),
      builder: (_, s) {
        if (s.hasData) {
          var dr = (DailyReflection.fromJson2List(s.data.toString())
                  as List<DailyReflection>)
              .firstWhere((x) => x.day == (day) && x.month == (month));
          var total = (DailyReflection.fromJson2List(s.data.toString())
              as List<DailyReflection>);

          int nextMonth, nextDay, prevMonth, prevDay;

          if (total.where((x) => x.month == dr.month).length > dr.day) {
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
            prevDay = total.where((x) => x.month == dr.month - 1).length;
          } else {
            prevMonth = 12;
            prevDay = 31;
          }

          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Scaffold(
                drawer: MainDrawer(),
                endDrawer: MainDrawer(),
                body: Directionality(
                  textDirection: Directionality.of(context),
                  child: Dismissible(
                    key: Key("drDis"),
                    resizeDuration: null,
                    direction: DismissDirection.horizontal,
                    background: DailyReflectionView(
                      month: (Directionality.of(context) == TextDirection.ltr)
                          ? prevMonth
                          : nextMonth,
                      day: (Directionality.of(context) == TextDirection.ltr)
                          ? prevDay
                          : nextDay,
                    ),
                    secondaryBackground: DailyReflectionView(
                      month: (Directionality.of(context) == TextDirection.ltr)
                          ? nextMonth
                          : prevMonth,
                      day: (Directionality.of(context) == TextDirection.ltr)
                          ? nextDay
                          : prevDay,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[600]
                                    : Colors.grey[200],
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              BackButton(),
                              Expanded(
                                child: Text(
                                  dr.title,
                                  maxLines: 2,
                                  textScaleFactor: 1.25,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Card(
                                      elevation: 20,
                                      child: Container(
                                        padding: EdgeInsets.all(12.0),
                                        child: Builder(
                                          builder: (context) {
                                            return InkWell(
                                              splashColor: Colors.red,
                                              onLongPress: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                      text: dr.excerpt),
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      trans(context,
                                                          "clipboard_copied_excerpt"),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "\n" +
                                                        intl.DateFormat.MMMMd(
                                                                Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode)
                                                            .format(
                                                          DateTime.parse(DateTime
                                                                      .now()
                                                                  .year
                                                                  .toString() +
                                                              ((month < 10)
                                                                  ? "-0"
                                                                  : "-") +
                                                              month.toString() +
                                                              ((day < 10)
                                                                  ? "-0"
                                                                  : "-") +
                                                              day.toString() +
                                                              " 00:00:00.000000"),
                                                        ) +
                                                        "\n",
                                                    style: TextStyle(
                                                      height: .25,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    dr.excerpt,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "\n" + dr.source,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Builder(
                                      builder: (context) {
                                        return InkWell(
                                          onLongPress: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                  text: dr.reflection),
                                            );
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  trans(context,
                                                      "clipboard_copied_reflection"),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            dr.reflection,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        );
                                      },
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
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
