import 'dart:math';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToolsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10.0),
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
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  trans(context, 'useful'),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: buildX(
                        context,
                        'btn_twelve_traditions',
                        'twelve_traditions',
                        'tradition_',
                        Colors.green[800],
                        12),
                  ),
                  const VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: buildX(
                      context,
                      'btn_twelve_steps',
                      'twelve_steps',
                      'step_',
                      Colors.teal[800],
                      12,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: buildX(
                      context,
                      'btn_twelve_promises',
                      'twelve_promises',
                      'promise_',
                      Colors.red[800],
                      12,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: buildX(
                      context,
                      'btn_j4t',
                      'j4t',
                      'j4t_',
                      Colors.pink[800],
                      9,
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

  Widget buildX(BuildContext context, String button, String header, String type,
      Color color, int x) {
    return RaisedButton(
      onPressed: () => showGeneralDialog<void>(
          context: context,
          pageBuilder: (BuildContext context, Animation<double> anim1,
                  Animation<double> anim2) =>
              null,
          barrierDismissible: true,
          transitionDuration: const Duration(milliseconds: 500),
          barrierColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          barrierLabel: '',
          transitionBuilder: (BuildContext context, Animation<double> anim1,
              Animation<double> anim2, Widget child) {
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
                      trans(context, header) + '\n',
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
                                                child: Container(
                                                  width: 120,
                                                  child: Text(
                                                    f.toString(),
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
      color: color,
    );
  }
}
