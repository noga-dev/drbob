import 'package:drbob/models/big_book.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BigBookView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = (Localizations.localeOf(context).languageCode == "he") ? "en" : Localizations.localeOf(context).languageCode;
    return FutureBuilder(
      future: rootBundle.loadString(
          "assets/big_book/$lang.big.book.json"),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.done) {
          var bigBook = BigBook.fromRawJson(future.data).chapter;
          return MyScaffold(
            implyLeading: true,
            title: Center(
              child: Text(
                trans(context, "title_big_book"),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List<Widget>.generate(
                    bigBook.keys.length,
                    (f) => OutlineButton(
                      borderSide: BorderSide(color: Colors.blue),
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(pageBuilder: (context, anim1, anime2) {
                          return MyScaffold(
                            implyLeading: true,
                            title: Center(
                              child: Text(bigBook.keys.elementAt(f)),
                            ),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: bigBook[bigBook.keys.elementAt(f)]
                                        .map(
                                          (x) => Text(x + "\n", textAlign: TextAlign.justify, textScaleFactor: 1.5,),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      child: Text(
                        bigBook.keys.elementAt(f),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return RefreshProgressIndicator();
      },
    );
  }
}