import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/models/daily_reflection.dart';
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
      ..quadraticBezierTo(size.width, 0, size.width * .5, 100)
      ..close();
    paint.color = layer3Color;
    canvas.drawPath(layer3, paint);

    Path layer4 = Path()
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width, 350, size.width * .5, size.height)
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
                  x.day == DateTime.now().day &&
                  x.month == DateTime.now().month);
              // .firstWhere((x) => x.month == 1 && x.day == 13);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                dr.title,
                softWrap: true,
                textAlign: TextAlign.justify,
                maxLines: 2,
              ),
            ),
            body: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CustomPaint(
                      child: Container(
                      ),
                      painter: DrBgCustomPainter(),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.9),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: RichText(
                          text: TextSpan(
                            text: '"${dr.excerpt}"',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                            children: [
                              TextSpan(
                                text: "\n\n",
                                children: [
                                  TextSpan(
                                      text: dr.source,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16)),
                                ],
                              ),
                            ],
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
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          dr.reflection,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
