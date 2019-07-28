import 'dart:math';
import 'dart:ui';

import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/tools/big_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'home/daily_reflection.dart';
import 'tools/daily_reflections.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Bloc>(context).flnp
      ..initialize(
        InitializationSettings(
          AndroidInitializationSettings("@mipmap/ic_launcher"),
          IOSInitializationSettings(),
        ),
        onSelectNotification: (String payload) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyReflectionView(
              month: DateTime.now().month,
              day: DateTime.now().day,
            ),
          ),
        ),
      );
    // #region Buttons
    var buttons = <Widget>[
      RaisedButton(
        color: Colors.lightBlue[800],
        child: Text(
          trans(context, "btn_big_book"),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BigBookView()),
        ),
      ),
      RaisedButton(
        color: Colors.pink[800],
        child: Text(
          trans(context, "btn_daily_reflections"),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DailyReflectionsListView()),
        ),
      ),
      buildTwelveX(context, "btn_twelve_traditions", "twelve_traditions",
          "tradition_", Colors.brown),
      buildTwelveX(context, "btn_twelve_steps", "twelve_steps", "step_",
          Colors.teal[800]),
      buildTwelveX(context, "btn_twelve_promises", "twelve_promises",
          "promise_", Colors.green[800]),
      buildModalText(context, Colors.indigo[800], "btn_serenity_prayer",
          "serenity_prayer"),
      buildModalText(context, Colors.purple[800], "btn_preamble", "preamble"),
    ];
    // #endregion
    return MyScaffold(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: SobrietySlider(
                          radius: 150,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: buttons,
                      )
                    ],
                  ),
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: buttons,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.fill,
                              child: SobrietySlider(
                                radius: 150,
                              ),
                            ),
                            Container(
                              height: 75,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                );
        },
      ),
      leading: Container(),
      title: Center(
        child: Text(
          trans(context, "title_home"),
        ),
      ),
      fab: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyReflectionView(
              month: DateTime.now().month,
              day: DateTime.now().day,
            ),
          ),
        ),
        label: Text(trans(context, "btn_todays_reflection"),
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget buildModalText(
      BuildContext context, Color color, String btnText, String modalText) {
    return RaisedButton(
      color: color,
      child: Text(
        trans(context, btnText),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: "",
            barrierColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            context: context,
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, anim1, anime2) {
              return;
            },
            transitionBuilder: (context, anim1, anim2, child) {
              String clipboard = "copied_to_clipboard";
              bool copied = false;
              return SafeArea(
                top: true,
                child: Opacity(
                  opacity: anim1.value,
                  child: SimpleDialog(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(0),
                    children: <Widget>[
                      StatefulBuilder(
                        builder: (context, s) {
                          return InkWell(
                            onLongPress: () {
                              s(() {
                                copied = true;
                                Clipboard.setData(
                                  ClipboardData(
                                    text: modalText,
                                  ),
                                );
                              });
                              Future.delayed(Duration(seconds: 2), () {
                                s(() {
                                  copied = false;
                                });
                              });
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              child: AnimatedDefaultTextStyle(
                                curve: Curves.ease,
                                duration: Duration(milliseconds: 2000),
                                style: copied
                                    ? TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)
                                    : TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                child: Text(
                                  (copied)
                                      ? trans(context, clipboard)
                                      : trans(context, modalText),
                                  textScaleFactor: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget buildTwelveX(BuildContext context, String button, String header,
      String type, Color color) {
    return RaisedButton(
      onPressed: () => showGeneralDialog(
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return;
          },
          barrierDismissible: true,
          transitionDuration: Duration(milliseconds: 500),
          barrierColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          barrierLabel: "",
          transitionBuilder: (context, anim1, anim2, child) {
            String temp = trans(context, "copied_to_clipboard");
            int selected = 0;
            return SafeArea(
              top: true,
              child: Opacity(
                opacity: anim1.value,
                child: Container(
                  margin: EdgeInsets.only(bottom: 60),
                  child: SimpleDialog(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      trans(context, header) + "\n",
                      textAlign: TextAlign.center,
                    ),
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        child: StatefulBuilder(
                          builder: (context, s) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<int>.generate(12, (int i) => ++i)
                                  .map(
                                    (f) => Wrap(
                                      children: <Widget>[
                                        InkWell(
                                          splashColor: Colors.primaries
                                              .toList()[Random().nextInt(
                                                  Colors.primaries.length)]
                                              .withOpacity(.5),
                                          onLongPress: () {
                                            s(() {
                                              selected = f;
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text: trans(
                                                    context,
                                                    type + f.toString(),
                                                  ),
                                                ),
                                              );
                                            });
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              s(() {
                                                selected = 0;
                                              });
                                            });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 2,
                                                child: Container(
                                                  width: 120,
                                                  child: Text(
                                                    f.toString(),
                                                    textScaleFactor: 2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 12,
                                                child: Container(
                                                  child:
                                                      AnimatedDefaultTextStyle(
                                                    curve: Curves.ease,
                                                    style: selected == f
                                                        ? TextStyle(
                                                            color: Colors.red)
                                                        : TextStyle(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    child: (selected == f)
                                                        ? Center(
                                                            child: Text(temp),
                                                          )
                                                        : Text(
                                                            trans(
                                                              context,
                                                              type +
                                                                  f.toString(),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        (f != 12)
                                            ? Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .2),
                                                child: Divider(
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      child: Text(
        trans(context, button),
        style: TextStyle(color: Colors.white),
      ),
      color: color,
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
        stroke: 10,
        blend: BlendMode.exclusion);

    canvas.save();

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    var listOfOffsets =
        List<int>.generate(dividers, (int index) => index).map((i) {
      var radians = min(size.width / 2, size.height / 2) +
          ((pi * 2) / dividers * i + 5.38);
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
      // WOW this is beatiful
      // canvas.drawArc(Rect.fromCenter(center: listOfOffsets[i],height: size.height, width: size.width), -pi / 2, arcAngle, false, sections);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
}

class SobrietySlider extends StatefulWidget {
  final double radius;
  SobrietySlider({Key key, this.radius}) : super(key: key);

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
          circleWidth: 12.0,
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
      borderRadius: BorderRadius.circular(widget.radius),
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
        height: widget.radius,
        width: widget.radius,
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
