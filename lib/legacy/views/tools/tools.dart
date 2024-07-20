import 'dart:math';

import 'package:drbob/legacy/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Directionality.of(context) == TextDirection.rtl
              ? const Border(
                  right: BorderSide(
                    width: 5,
                    color: Colors.lightGreen,
                  ),
                )
              : const Border(
                  left: BorderSide(
                    width: 5,
                    color: Colors.lightGreen,
                  ),
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  trans(context, 'useful'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Y(
                      button: 'btn_twelve_traditions',
                      header: 'twelve_traditions',
                      type: 'tradition_',
                      color: Colors.green,
                      x: 12,
                    ),
                  ),
                  VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: Y(
                      button: 'btn_twelve_steps',
                      header: 'twelve_steps',
                      type: 'step_',
                      color: Colors.teal,
                      x: 12,
                    ),
                  ),
                ],
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Y(
                      button: 'btn_twelve_promises',
                      header: 'twelve_promises',
                      type: 'promise_',
                      color: Colors.red,
                      x: 12,
                    ),
                  ),
                  VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: Y(
                      button: 'btn_j4t',
                      header: 'j4t',
                      type: 'j4t_',
                      color: Colors.pink,
                      x: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Y extends StatelessWidget {
  const Y({
    super.key,
    required this.button,
    required this.header,
    required this.type,
    required this.color,
    required this.x,
  });

  final String button;
  final String header;
  final String type;
  final Color color;
  final int x;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showGeneralDialog<void>(
          context: context,
          pageBuilder: (
            BuildContext context,
            Animation<double> anim1,
            Animation<double> anim2,
          ) =>
              const SizedBox(),
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
          ) {
            final String temp = trans(context, 'copied_to_clipboard');
            int selected = 0;
            return SafeArea(
              top: true,
              child: Opacity(
                opacity: anim1.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: SimpleDialog(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      '${trans(context, header)}\n',
                      textAlign: TextAlign.center,
                    ),
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        child: StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<int>.generate(x, (int i) => ++i)
                                  .map(
                                    (int f) => Wrap(
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
                                            Future<void>.delayed(
                                              const Duration(seconds: 2),
                                              () => s(() => selected = 0),
                                            );
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 2,
                                                child: SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    f.toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 12,
                                                child: AnimatedDefaultTextStyle(
                                                  curve: Curves.ease,
                                                  style: selected == f
                                                      ? const TextStyle(
                                                          color: Colors.red)
                                                      : TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black),
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
                                                            type + f.toString(),
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
                                        if (f != x)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .2),
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
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
