import 'dart:math';
import 'package:drbob/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'blocs/Bloc.dart';
import 'ui/common.dart';
import 'utils/localization.dart';

class NavDrawer extends StatelessWidget {
  final Divider divider = const Divider(
    thickness: 2,
    indent: 50,
    endIndent: 50,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[
      AnimatedMenuItem(
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            trans(
              context,
              'btn_home',
            ),
          ),
          subtitle: Text(
            trans(
              context,
              'btn_home_desc',
            ),
          ),
          trailing: ModalRoute.of(context).settings.name != '/'
              ? null
              : Icon(
                  Icons.arrow_left,
                  color: Colors.red,
                  size: 40,
                ),
        ),
        () => Navigator.pushReplacementNamed(
          context,
          '/',
        ),
      ),
      divider,
      AnimatedMenuItem(
        ListTile(
          leading: Icon(Icons.book),
          title: Text(
            trans(context, 'btn_bb'),
          ),
          subtitle: Text(
            trans(
              context,
              'btn_bb_desc',
            ),
          ),
          trailing: ModalRoute.of(context).settings.name != '/bb'
              ? null
              : Icon(
                  Icons.arrow_left,
                  color: Colors.red,
                  size: 40,
                ),
        ),
        () => Navigator.pushReplacementNamed(
          context,
          '/bb',
        ),
      ),
      divider,
      AnimatedMenuItem(
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            trans(context, 'btn_dr_list'),
          ),
          subtitle: Text(
            trans(
              context,
              'btn_dr_list_desc',
            ),
          ),
          trailing: ModalRoute.of(context).settings.name != '/dr'
              ? null
              : Icon(
                  Icons.arrow_left,
                  color: Colors.red,
                  size: 40,
                ),
        ),
        () => Navigator.pushReplacementNamed(
          context,
          '/dr',
        ),
      ),
    ];
    return Drawer(
      elevation: 0,
      child: Container(
        color: mainBgColor(context),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items,
          ),
        ),
      ),
    );
  }

  Widget buildX(
      {BuildContext context,
      IconData icon,
      String button,
      String sub,
      String type,
      String header,
      int x}) {
    return AnimatedMenuItem(
        ListTile(
          leading: Icon(icon),
          title: Text(
            trans(context, button),
          ),
          subtitle: Text(
            trans(
              context,
              sub,
            ),
          ),
        ),
        () => showGeneralDialog<void>(
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              Provider.of<Bloc>(
                                                                      context)
                                                                  .getFontSize),
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
                                                              color: Colors.red,
                                                            )
                                                          : TextStyle(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: Provider
                                                                      .of<Bloc>(
                                                                          context)
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
                                              child: Divider(
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
            }));
  }

  Widget buildModalText(
      {BuildContext context,
      IconData icon,
      String sub,
      String title,
      String modalText}) {
    return AnimatedMenuItem(
      ListTile(
        leading: Icon(icon),
        title: Text(
          trans(
            context,
            title,
          ),
        ),
        subtitle: Text(trans(context, sub)),
      ),
      () => showGeneralDialog<void>(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        context: context,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> anim1,
            Animation<double> anime2) {
          return;
        },
        transitionBuilder: (BuildContext context, Animation<double> anim1,
            Animation<double> anim2, Widget child) {
          const String clipboard = 'copied_to_clipboard';
          bool copied = false;
          return SafeArea(
            top: true,
            child: Opacity(
              opacity: anim1.value,
              child: SimpleDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(0),
                children: <Widget>[
                  StatefulBuilder(
                    builder: (BuildContext context, Function s) => InkWell(
                      onLongPress: () {
                        s(() {
                          copied = true;
                          Clipboard.setData(
                            ClipboardData(
                              text: modalText,
                            ),
                          );
                        });
                        Future<dynamic>.delayed(
                          const Duration(seconds: 2),
                          () => s(
                            () => copied = false,
                          ),
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        child: AnimatedDefaultTextStyle(
                          curve: Curves.ease, // TODO(AN): Randomize Curves?
                          duration: const Duration(
                            milliseconds: 2000,
                          ),
                          style: copied
                              ? TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                )
                              : TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      Provider.of<Bloc>(context).getFontSize,
                                ),
                          child: Text(
                            copied
                                ? trans(
                                    context,
                                    clipboard,
                                  )
                                : trans(
                                    context,
                                    modalText,
                                  ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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