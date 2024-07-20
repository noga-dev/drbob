import 'dart:math';

import 'package:drbob/blocs/bloc.dart';
import 'package:drbob/ui/common.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> kids = <Widget>[
      Container(
        height: 140,
        width: 140,
        padding: const EdgeInsets.all(10),
        child: const SobrietySlider(
          radius: 120,
        ),
      ),
      Container(
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const UserStatistics(),
      ),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: kids,
        ),
        Container(
          height: 10,
        ),
        const X(
          icon: Icons.directions_walk,
          button: 'btn_ts',
          header: 'twelve_steps',
          type: 'step_',
          sub: 'btn_ts_desc',
          x: 12,
        ),
        const X(
          icon: Icons.bookmark,
          button: 'btn_tt',
          header: 'twelve_traditions',
          type: 'tradition_',
          sub: 'btn_tt_desc',
          x: 12,
        ),
        const ModalText(
          title: 'btn_sp',
          sub: 'btn_sp_desc',
          text: 'serenity_prayer',
          icon: Icons.dashboard,
        ),
        const ModalText(
          title: 'btn_preamble',
          sub: 'btn_preamble_desc',
          text: 'preamble',
          icon: Icons.local_florist,
        ),
        MenuItem(
          icon: Icons.group_work,
          label: trans(
            context,
            'btn_hiw',
          ),
          func: () => showGeneralDialog<void>(
            context: context,
            pageBuilder: (
              BuildContext context,
              Animation<double> anim1,
              Animation<double> anim2,
            ) =>
                const SizedBox.shrink(),
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 500),
            barrierColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            barrierLabel: '',
            transitionBuilder: (
              BuildContext context,
              Animation<double> anim1,
              Animation<double> anim2,
              Widget child,
            ) =>
                SimpleDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ), // TODO(AN): Prettify this
                  child: Builder(
                    builder: (BuildContext context) {
                      return DefaultTextStyle(
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: Provider.of<Bloc>(context).getFontSize),
                        child: Text(
                          '${trans(context, 'hiw_1')}\n\n${trans(context, 'hiw_2')}\n\n${trans(context, 'hiw_3')}\n\n${trans(context, 'hiw_4')}\n\n${trans(context, 'hiw_5')}\n\n${trans(context, 'hiw_6')}\n\n1. ${trans(context, 'step_1')}\n2. ${trans(context, 'step_2')}\n3. ${trans(context, 'step_3')}\n4. ${trans(context, 'step_4')}\n5. ${trans(context, 'step_5')}\n6. ${trans(context, 'step_6')}\n7. ${trans(context, 'step_7')}\n8. ${trans(context, 'step_8')}\n9. ${trans(context, 'step_9')}\n10. ${trans(context, 'step_10')}\n11. ${trans(context, 'step_11')}\n12. ${trans(context, 'step_12')}\n\n${trans(context, 'hiw_7')}\n\n${trans(context, 'hiw_8')}\n\n${trans(context, 'hiw_9')}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tooltip(
        //   message: trans(context, 'disabled_func'),
        //   child: menuItem(
        //     icon: Icons.location_on,
        //     label: trans(
        //       context,
        //       'btn_find_a_meeting',
        //     ),
        //     func: null,
        //   ),
        // ),
      ],
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter({
    required this.darkTheme,
    required this.oldChipColor,
    required this.newChipColor,
    required this.dividerColor,
    required this.completedPercentage,
    required this.circleWidth,
    required this.dividers,
  });

  bool darkTheme;
  Color oldChipColor;
  Color newChipColor;
  Color dividerColor;
  double completedPercentage;
  double circleWidth;
  int dividers;

  Paint getPaint(
      {Color color = Colors.purple,
      PaintingStyle style = PaintingStyle.stroke,
      double stroke = 7,
      StrokeCap cap = StrokeCap.round,
      BlendMode blend = BlendMode.srcOver,
      required ColorFilter cFilter,
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
    final Paint defaultCirclePaint = getPaint(
      color: oldChipColor,
      stroke: circleWidth,
      cap: StrokeCap.round,
      cFilter: ColorFilter.mode(
        oldChipColor,
        BlendMode.srcIn,
      ),
    );
    final Paint progressCirclePaint = getPaint(
      color: newChipColor,
      stroke: circleWidth,
      cap: StrokeCap.butt,
      cFilter: ColorFilter.mode(
        oldChipColor,
        BlendMode.srcIn,
      ),
    );
    final Paint sections = getPaint(
      color: dividerColor,
      cap: StrokeCap.round,
      invert: darkTheme,
      stroke: 10,
      blend: BlendMode.exclusion,
      cFilter: ColorFilter.mode(
        oldChipColor,
        BlendMode.srcIn,
      ),
    );

    canvas.save();

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    final List<Offset> listOfOffsets =
        List<int>.generate(dividers, (int index) => index).map((int i) {
      final double radians = min(size.width / 2, size.height / 2) +
          ((pi * 2) / dividers * i + 5.2);
      return Offset(
        center.dx + radius * cos(radians),
        center.dy + radius * sin(radians),
      );
    }).toList();

    canvas.drawCircle(center, radius, defaultCirclePaint);

    final double arcAngle = 2 * pi * (completedPercentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressCirclePaint);

    for (int i = 0; i < dividers; i++) {
      canvas.drawLine(listOfOffsets[i], listOfOffsets[i], sections);
      // WOW this is beatiful
      // canvas.drawArc(Rect.fromCenter(center: listOfOffsets[i],height: size.height, width: size.width), -pi / 2, arcAngle, false, sections);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SobrietySlider extends StatefulWidget {
  const SobrietySlider({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  _SobrietySliderState createState() => _SobrietySliderState();
}

class _SobrietySliderState extends State<SobrietySlider>
    with TickerProviderStateMixin {
  late AnimationController _radialProgressAnimationController;
  late Animation<double> _progressAnimation;
  double goalCompleted = 0;
  double progressDegrees = 0;

  @override
  void initState() {
    super.initState();

    _progressAnimation = const AlwaysStoppedAnimation<double>(0);

    _radialProgressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    _radialProgressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _radialProgressAnimationController,
        curve: Curves.decelerate,
      ),
    )..addListener(
        () => setState(
          () => progressDegrees = goalCompleted * _progressAnimation.value,
        ),
      );

    _radialProgressAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    initSobrietyDate();
    super.didChangeDependencies();
  }

  CustomPaint progressView() {
    return CustomPaint(
      foregroundPainter: ProgressPainter(
        darkTheme: Theme.of(context).brightness == Brightness.dark,
        oldChipColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.grey,
        newChipColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        dividerColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        completedPercentage: progressDegrees,
        circleWidth: 12.0,
        dividers: 12,
      ),
      child: DefaultTextStyle(
        style: statisticsStyle.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color),
        child: Center(
          child: (progressDegrees == 0)
              ? Center(
                  child: Text(
                    trans(context, 'pick_sobriety_date'),
                    textAlign: TextAlign.center,
                  ),
                )
              : Text('${progressDegrees.toStringAsFixed(2)}%'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO(AN): duplicate code from drawer-> refactor later
    final prefs = Provider.of<Bloc>(context).getPrefs;
    final hasSobrietyDate = prefs.containsKey('sobrietyDateInt');
    final now = DateTime.now();
    final sobDate = hasSobrietyDate
        ? DateTime.fromMillisecondsSinceEpoch(
            prefs.getInt('sobrietyDateInt') ?? 0)
        : now;

    return InkWell(
      borderRadius: BorderRadius.circular(widget.radius),
      onTap: () async {
        final result = await showDatePicker(
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          context: context,
          initialDate: sobDate,
          lastDate: DateTime.now(),
        );

        if (result != null) {
          setState(() {
            prefs.setInt(
              'sobrietyDateInt',
              result.millisecondsSinceEpoch,
            );

            Provider.of<Bloc>(context).notify();
          });
        }
      },
      child: Tooltip(
        message: trans(context, 'disabled_func'),
        child: SizedBox(
          height: widget.radius,
          width: widget.radius,
          child: progressView(),
        ),
      ),
    );
  }

  // TODO(AN): Add next chip indicator
  void initSobrietyDate() {
    setState(() {
      _radialProgressAnimationController.reset();
      _radialProgressAnimationController.forward();
      final Duration sobrietyTime = Provider.of<Bloc>(context).getSobrietyTime;
      // average days in year and month
      final double days = sobrietyTime.inDays % 365.2425 % 30.44;
      if (sobrietyTime.inDays >= 365) {
        goalCompleted = sobrietyTime.inDays.toDouble() % 365.2425 / 365.2425;
      } else if (sobrietyTime.inDays > 30 && sobrietyTime.inDays <= 60) {
        goalCompleted = days / 60.88;
      } else if (sobrietyTime.inDays > 60 && sobrietyTime.inDays <= 90) {
        goalCompleted = days / 91;
      } else if (sobrietyTime.inDays > 90 && sobrietyTime.inDays <= 180) {
        goalCompleted = days / 180;
      } else if (sobrietyTime.inDays > 180 && sobrietyTime.inDays < 365) {
        goalCompleted = days / 365;
      } else {
        goalCompleted = days / 30.44;
      }
    });
  }
}

class UserStatistics extends StatefulWidget {
  const UserStatistics({super.key});

  @override
  _UserStatisticsState createState() => _UserStatisticsState();
}

class _UserStatisticsState extends State<UserStatistics> {
  bool type = false;

  @override
  Widget build(BuildContext context) {
    final Duration sobrietyTime = Provider.of<Bloc>(context).getSobrietyTime;
    final int years = sobrietyTime.inDays ~/ 365.2425;
    final int months = sobrietyTime.inDays % 365.2425 ~/ 30.44;
    final int days = (sobrietyTime.inDays % 365.2425 % 30.44).toInt();

    return InkWell(
      borderRadius: BorderRadius.circular(150),
      onTap: () => setState(() => type = !type),
      child: !Provider.of<Bloc>(context).getPrefs.containsKey('sobrietyDateInt')
          ? Center(
              child: Text(
                trans(
                  context,
                  'sobriety_date_not_set',
                ),
              ),
            )
          : SizedBox(
              width: 100,
              height: 100,
              child: DefaultTextStyle(
                style: statisticsStyle.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color),
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: type
                      ? Center(
                          child: Text(
                            '${sobrietyTime.inDays} ${trans(context, 'total_sobriety_days')}',
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$years ${trans(context, 'years')}',
                            ),
                            Text(
                              '$months ${trans(context, 'months')}',
                            ),
                            Text(
                              '$days ${trans(context, 'days')}',
                            ),
                          ],
                        ),
                ),
              ),
            ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton(this.title, this.sub, this.icon, {super.key});

  final String title;
  final String sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 80,
      child: InkWell(
        onTap: () {},
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  colors: <Color>[
                    Colors.purple,
                    Colors.teal,
                  ],
                  begin: FractionalOffset(
                    0.0,
                    0.0,
                  ),
                  end: FractionalOffset(
                    0.5,
                    0.0,
                  ),
                  stops: <double>[
                    0.0,
                    1.0,
                  ],
                  tileMode: TileMode.clamp),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 30,
                  child: Icon(icon),
                ),
                Positioned(
                  right: 20,
                  child: Text(
                    title,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.func,
  });

  final String label;
  final IconData icon;
  final Future<void> Function() func;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 200,
      child: Card(
        color: Colors.transparent,
        child: AnimatedMenuItem(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 20,
                ),
                Expanded(child: Text(label)),
                Icon(icon),
                Container(
                  width: 20,
                ),
              ],
            ),
            func),
      ),
    );
  }
}

class ModalText extends StatefulWidget {
  const ModalText({
    super.key,
    required this.icon,
    required this.sub,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String sub;
  final String title;
  final String text;

  @override
  State<ModalText> createState() => _ModalTextState();
}

class _ModalTextState extends State<ModalText> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: widget.icon,
      label: trans(
        context,
        widget.title,
      ),
      func: () => showGeneralDialog<void>(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        context: context,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (
          BuildContext context,
          Animation<double> anim1,
          Animation<double> anime2,
        ) {
          return const SizedBox.shrink();
        },
        transitionBuilder: (
          BuildContext context,
          Animation<double> anim1,
          Animation<double> anim2,
          Widget child,
        ) {
          const String clipboard = 'copied_to_clipboard';

          return SafeArea(
            top: true,
            child: Opacity(
              opacity: anim1.value,
              child: SimpleDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                children: <Widget>[
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        copied = true;
                        Clipboard.setData(
                          ClipboardData(
                            text: widget.text,
                          ),
                        );
                      });
                      Future<dynamic>.delayed(
                        const Duration(seconds: 2),
                        () => setState(
                          () => copied = false,
                        ),
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: AnimatedDefaultTextStyle(
                      curve: Curves.ease, // TODO(AN): Randomize Curves?
                      duration: const Duration(
                        milliseconds: 2000,
                      ),
                      style: copied
                          ? const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            )
                          : TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Provider.of<Bloc>(context).getFontSize,
                            ),
                      child: Text(
                        copied
                            ? trans(
                                context,
                                clipboard,
                              )
                            : trans(
                                context,
                                widget.text,
                              ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class X extends StatefulWidget {
  const X({
    super.key,
    required this.icon,
    required this.button,
    required this.sub,
    required this.type,
    required this.header,
    required this.x,
  });

  final IconData icon;
  final String button;
  final String sub;
  final String type;
  final String header;
  final int x;

  @override
  State<X> createState() => _XState();
}

class _XState extends State<X> {
  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: widget.icon,
      label: trans(
        context,
        widget.button,
      ),
      func: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            final temp = trans(context, 'copied_to_clipboard');
            int selected = 0;

            return SafeArea(
              top: true,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    trans(context, widget.header),
                  ),
                ),
                body: ListView(
                  children: List.generate(
                    widget.x,
                    (int i) => ++i,
                  )
                      .map(
                        (int f) => Wrap(
                          children: [
                            ListTile(
                              splashColor: Colors.primaries
                                  .toList()[
                                      Random().nextInt(Colors.primaries.length)]
                                  .withOpacity(.5),
                              onLongPress: () {
                                setState(() {
                                  selected = f;
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: trans(
                                        context,
                                        widget.type + f.toString(),
                                      ),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('copied to clipboard'),
                                    ),
                                  );
                                });
                                Future<void>.delayed(
                                  const Duration(seconds: 2),
                                  () => setState(() => selected = 0),
                                );
                              },
                              title: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(
                                        f.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: Provider.of<Bloc>(context)
                                                .getFontSize),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 12,
                                    child: AnimatedDefaultTextStyle(
                                      curve: Curves.ease,
                                      style: selected == f
                                          ? const TextStyle(
                                              color: Colors.red,
                                            )
                                          : TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize:
                                                  Provider.of<Bloc>(context)
                                                      .getFontSize),
                                      duration: const Duration(
                                        milliseconds: 4000,
                                      ),
                                      child: (selected == f)
                                          ? Center(
                                              child: Text(temp),
                                            )
                                          : Text(
                                              trans(
                                                context,
                                                widget.type + f.toString(),
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
                            if (f != widget.x)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * .2),
                                child: const Divider(
                                  color: Colors.grey,
                                ),
                              )
                            else
                              Container()
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
