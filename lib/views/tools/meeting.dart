import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeetingView extends StatelessWidget {
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
                      color: Colors.purple,
                    ),
                  )
                : const Border(
                    left: BorderSide(
                      width: 5,
                      color: Colors.purple,
                    ),
                  ),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  trans(context, 'meetings'),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: buildModalText(
                      context,
                      Colors.indigo[800],
                      'btn_serenity_prayer',
                      'serenity_prayer',
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: buildModalText(
                      context,
                      Colors.purple[800],
                      'btn_preamble',
                      'preamble',
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.brown[600],
                      child: Text(
                        trans(context, 'hiw'),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => MyScaffold(
                            implyLeading: true,
                            title: Center(
                              child: Text(
                                trans(
                                  context,
                                  'hiw',
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ), // TODO(AN): Prettify this horrorshow
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      trans(context, 'hiw_1') +
                                          '\n\n' +
                                          trans(context, 'hiw_2') +
                                          '\n\n' +
                                          trans(context, 'hiw_3') +
                                          '\n\n' +
                                          trans(context, 'hiw_4') +
                                          '\n\n' +
                                          trans(context, 'hiw_5') +
                                          '\n\n' +
                                          trans(context, 'hiw_6') +
                                          '\n\n1. ' +
                                          trans(context, 'step_1') +
                                          '\n2. ' +
                                          trans(context, 'step_2') +
                                          '\n3. ' +
                                          trans(context, 'step_3') +
                                          '\n4. ' +
                                          trans(context, 'step_4') +
                                          '\n5. ' +
                                          trans(context, 'step_5') +
                                          '\n6. ' +
                                          trans(context, 'step_6') +
                                          '\n7. ' +
                                          trans(context, 'step_7') +
                                          '\n8. ' +
                                          trans(context, 'step_8') +
                                          '\n9. ' +
                                          trans(context, 'step_9') +
                                          '\n10. ' +
                                          trans(context, 'step_10') +
                                          '\n11. ' +
                                          trans(context, 'step_11') +
                                          '\n12. ' +
                                          trans(context, 'step_12') +
                                          '\n\n' +
                                          trans(context, 'hiw_7') +
                                          '\n\n' +
                                          trans(context, 'hiw_8') +
                                          '\n\n' +
                                          trans(context, 'hiw_9'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 10,
                  ),
                  Expanded(
                    child: Tooltip(
                      message: trans(context, 'disabled_func'),
                      child: FlatButton(
                        onPressed: null,
                        child: Text(
                          trans(
                            context,
                            'find_a_meeting',
                          ),
                        ),
                      ),
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

  Widget buildModalText(
      BuildContext context, Color color, String btnText, String modalText) {
    return RaisedButton(
      color: color,
      child: Text(
        trans(context, btnText),
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showGeneralDialog<void>(
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
                              curve: Curves.ease, // TODO(AN): Randomize?
                              duration: const Duration(milliseconds: 2000),
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
                                    ),
                              child: Text(
                                copied
                                    ? trans(context, clipboard)
                                    : trans(context, modalText),
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
            });
      },
    );
  }
}
