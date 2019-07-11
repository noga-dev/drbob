import 'dart:math';
import 'dart:ui';

import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tools/daily_reflections.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SobrietySlider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              buildDrList(context),
              buildSerenityPrayer(context),
              buildPreamble(context),
              buildTwelveSteps(context),
              buildTwelveTraditions(context),
              Container(
                margin: EdgeInsets.only(bottom: 200),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTwelveTraditions(BuildContext context) {
    return RaisedButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                trans(context, "twelve_traditions") + "\n",
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List<int>.generate(12, (int i) => ++i)
                          .map(
                            (f) => Wrap(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          f.toString(),
                                          textScaleFactor: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Text(
                                          trans(
                                            context,
                                            "tradition_" + f.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (f != 12) ? Divider() : Container()
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            );
          }),
      child: Text(
        trans(context, "btn_twelve_traditions"),
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.teal[700],
    );
  }

  Widget buildTwelveSteps(BuildContext context) {
    return RaisedButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                trans(context, "twelve_steps") + "\n",
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List<int>.generate(12, (int i) => ++i)
                          .map(
                            (f) => Wrap(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          f.toString(),
                                          textScaleFactor: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Text(
                                          trans(
                                            context,
                                            "step_" + f.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (f != 12) ? Divider() : Container()
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            );
          }),
      color: Colors.brown,
      child: Text(
        trans(context, "btn_twelve_steps"),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  RaisedButton buildPreamble(BuildContext context) {
    return RaisedButton(
      color: Colors.indigo,
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    trans(context, "preamble"),
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }),
      child: Text(
        trans(context, "btn_preamble"),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  RaisedButton buildDrList(BuildContext context) {
    return RaisedButton(
      color: Colors.pink[700],
      child: Text(
        trans(context, "btn_daily_reflections"),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DailyReflectionsListView()),
      ),
    );
  }

  Widget buildSerenityPrayer(BuildContext context) {
    return RaisedButton(
      color: Colors.purple,
      child: Text(
        trans(context, "btn_serenity_prayer"),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      trans(context, "serenity_prayer"),
                      textAlign: TextAlign.center,
                      textScaleFactor: 2,
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  bool darkTheme;
  Color oldChipColor;
  Color newChipColor;
  Color dividerColor;
  double completedPercentage;
  double circleWidth;
  int dividers;

  ProgressPainter(
      {this.darkTheme,
      this.oldChipColor,
      this.newChipColor,
      this.dividerColor,
      this.completedPercentage,
      this.circleWidth,
      this.dividers});

  getPaint(
      {Color color = Colors.purple,
      PaintingStyle style = PaintingStyle.stroke,
      double stroke = 7,
      StrokeCap cap = StrokeCap.round,
      BlendMode blend = BlendMode.srcOver,
      ColorFilter cFilter,
      bool invert = false}) {
    return Paint()
      ..color = color
      ..strokeCap = cap
      ..style = style
      ..blendMode = blend
      ..invertColors = invert
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint defaultCirclePaint = getPaint(
      color: oldChipColor,
      stroke: circleWidth,
      cap: StrokeCap.round,
    );
    Paint progressCirclePaint = getPaint(
      color: newChipColor,
      stroke: circleWidth,
      cap: StrokeCap.butt,
    );
    Paint sections = getPaint(
        color: dividerColor,
        cap: StrokeCap.round,
        invert: darkTheme,
        blend: BlendMode.exclusion);

    canvas.save();

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    var listOfOffsets =
        List<int>.generate(dividers, (int index) => index).map((i) {
      var radians = min(size.width / 2, size.height / 2) +
          ((pi * 2) / dividers * i + 5.25);
      return Offset(
        center.dx + radius * cos(radians),
        center.dy + radius * sin(radians),
      );
    }).toList();

    canvas.drawCircle(center, radius, defaultCirclePaint);

    double arcAngle = 2 * pi * (completedPercentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressCirclePaint);

    for (var i = 0; i < dividers; i++) {
      canvas.drawLine(listOfOffsets[i], listOfOffsets[i], sections);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
}

class SobrietySlider extends StatefulWidget {
  SobrietySlider() : super();

  @override
  _SobrietySliderState createState() => _SobrietySliderState();
}

class _SobrietySliderState extends State<SobrietySlider>
    with SingleTickerProviderStateMixin {
  AnimationController _radialProgressAnimationController;
  Animation<double> _progressAnimation;
  DateTime _sobrietyDate;
  Duration _sobrietyTime;
  int sobrietyTimeYears = 0, sobrietyTimeMonths = 0, sobrietyTimeDays = 0;
  double goalCompleted = 0, progressDegrees = 0;

  @override
  initState() {
    super.initState();

    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _progressAnimation = Tween(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _radialProgressAnimationController,
        curve: Curves.decelerate,
      ),
    )..addListener(() {
        setState(() {
          progressDegrees = goalCompleted * _progressAnimation.value;
        });
      });
    _radialProgressAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    initSobrietyDate();
    super.didChangeDependencies();
  }

  progressView() {
    return CustomPaint(
      child: Center(
        child: Text(
          progressDegrees.toStringAsFixed(2).toString() + "%",
          textScaleFactor: 1.25,
        ),
      ),
      foregroundPainter: ProgressPainter(
          darkTheme:
              (Theme.of(context).brightness == Brightness.dark) ? true : false,
          oldChipColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[300],
          newChipColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          dividerColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          completedPercentage: progressDegrees,
          circleWidth: 10.0,
          dividers: 12),
    );
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          if (!Provider.of<Bloc>(context)
              .getPrefs
              .containsKey("sobrietyDateInt"))
            return Center(
              child: Text(
                trans(context, "sobriety_date_not_set"),
              ),
            );
          return ListView(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        trans(context, "total_sobriety_time"),
                      ),
                      Column(
                        children: <Widget>[
                          Text(trans(context, "years")),
                          Divider(
                            height: 4,
                            color: Colors.green,
                          ),
                          Text(sobrietyTimeYears.toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(trans(context, "months")),
                          Divider(
                            height: 4,
                            color: Colors.green,
                          ),
                          Text(sobrietyTimeMonths.toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(trans(context, "days")),
                          Divider(
                            height: 4,
                            color: Colors.green,
                          ),
                          Text(sobrietyTimeDays.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        trans(context, "total_sobriety_days"),
                      ),
                      Text(_sobrietyTime.inDays.toString()),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        height: 200,
        width: 200,
        alignment: Alignment.center,
        child: progressView(),
      ),
    );
  }

  initSobrietyDate() {
    if (!Provider.of<Bloc>(context).getPrefs.containsKey("sobrietyDateInt"))
      return;
    setState(() {
      _radialProgressAnimationController.reset();
      _radialProgressAnimationController.forward();
      _sobrietyDate = DateTime.fromMillisecondsSinceEpoch(
          Provider.of<Bloc>(context).getPrefs.getInt("sobrietyDateInt"));
      _sobrietyTime = DateTime.now().difference(_sobrietyDate);
      var years = (_sobrietyTime.inDays ~/ 365.2425);
      var months = (_sobrietyTime.inDays % 365.2425 ~/ 30.44);
      var days = (_sobrietyTime.inDays % 365.2425 % 30.44);
      sobrietyTimeYears = years.toInt() ?? 0;
      sobrietyTimeMonths = months.toInt() ?? 0;
      sobrietyTimeDays = days.toInt() ?? 0;
      if (_sobrietyTime.inDays >= 365)
        goalCompleted = _sobrietyTime.inDays.toDouble() % 365.2425 / 365.2425;
      else
        goalCompleted = days / 30.44;
    });
  }
}
