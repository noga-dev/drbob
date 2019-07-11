import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/main_drawer.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
              .firstWhere((x) =>
                  x.day == (day ?? DateTime.now().day) &&
                  x.month == (month ?? DateTime.now().month));
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

          return Scaffold(
            drawer: MainDrawer(),
            body: SafeArea(
              child: Dismissible(
                key: Key("disHoriz"),
                background: Container(
                  child: RotatedBox(
                    quarterTurns: (Directionality.of(context) == TextDirection.ltr) ? 3 : 1,
                    child: Text(
                      trans(context, "go_back"),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  child: RotatedBox(
                    quarterTurns: (Directionality.of(context) == TextDirection.ltr) ? 1 : 3,
                    child: Text(
                      trans(context, "go_back"),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                onDismissed: (d) {
                  Navigator.pop(context);
                },
                child: Dismissible(
                  key: Key("disVert"),
                  resizeDuration: null,
                  direction: DismissDirection.vertical,
                  background: DailyReflectionView(
                    month: prevMonth,
                    day: prevDay,
                  ),
                  secondaryBackground: DailyReflectionView(
                    month: nextMonth,
                    day: nextDay,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          BackButton(),
                          Container(
                            padding: EdgeInsets.only(top: 6),
                            width: MediaQuery.of(context).size.width * .5,
                            child: Text(
                              dr.title,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    trans(context, "month_colon") +
                                        (month?.toString() ??
                                            DateTime.now().month.toString()),
                                  ),
                                  Text(
                                    trans(context, "day_colon") +
                                        (day?.toString() ??
                                            DateTime.now().day.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
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
                                          ClipboardData(text: dr.excerpt),
                                        );
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              trans(context,
                                                  "clipboard_copied_excerpt"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            dr.excerpt,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "\n" + dr.source,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Builder(
                                builder: (context) {
                                  return InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(
                                        ClipboardData(text: dr.reflection),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: RefreshProgressIndicator(),
          );
        }
      },
    );
  }
}