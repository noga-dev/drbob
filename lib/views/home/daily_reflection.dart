import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/models/daily_reflection.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DrBgCustomPainter extends CustomPainter {
  Color mainBgColor = Colors.orange;
  Color layer2Color = Colors.red;
  Color layer3Color = Colors.blue;
  Color layer4Color = Colors.green;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Path mainBgPath = Path()
      ..lineTo(0, 0)
      ..addRect(Rect.fromLTWH(.0, .0, size.width, size.height));
    paint.color = mainBgColor;
    canvas.drawPath(mainBgPath, paint);

    Path layer2 = Path()
      ..lineTo(size.width, 0)
      ..quadraticBezierTo(size.width, size.height, 100, 100)
      ..close();
    paint.color = layer2Color;
    canvas.drawPath(layer2, paint);

    Path layer3 = Path()
      ..lineTo(-100, 200)
      ..quadraticBezierTo(size.width * .75, -300, size.width * .25, 100)
      ..close();
    paint.color = layer3Color;
    canvas.drawPath(layer3, paint);

    Path layer4 = Path()
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width, 250, size.width * .25, size.height)
      ..close();
    paint.color = layer4Color;
    canvas.drawPath(layer4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

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
            body: SafeArea(
              child: Dismissible(
                key: Key("dr${month.toString()}_${day.toString()}"),
                resizeDuration: null,
                direction: DismissDirection.vertical,
                background: DailyReflectionView(month: (dr.month < 12) ? dr.month+1 : 1, day: 1,),
                secondaryBackground: DailyReflectionView(month: (dr.month > 1) ? dr.month-1 : 12, day: 1,),
                child: Dismissible(
                  key: Key("dr${month.toString()}_${day.toString()}"),
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          BackButton(),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: Text(
                              dr.title,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.center,
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
                          // CustomPaint(
                          //   child: Container(),
                          //   painter: DrBgCustomPainter(),
                          // ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(),
                            child: Card(
                              elevation: 20,
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Provider.of<Bloc>(context)
                                              .getTheme
                                              .brightness ==
                                          Brightness.light
                                      ? Colors.white.withOpacity(.9)
                                      : Colors.black.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
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
                                      style: TextStyle(fontSize: 22),
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
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  SlideRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}
