import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:drbob/models/big_book.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BigBookView extends StatefulWidget {
  @override
  _BigBookViewState createState() => _BigBookViewState();
}

class _BigBookViewState extends State<BigBookView> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController();
  }

  bool _disclaimer;

  @override
  Widget build(BuildContext context) {
    // TODO: Implement translations
    var lang = (Localizations.localeOf(context).languageCode == "en")
        ? Localizations.localeOf(context).languageCode
        : "en";
    _disclaimer =
        Localizations.localeOf(context).languageCode == "en" ? false : true;
    return MyScaffold(
      implyLeading: true,
      title: Center(
        child: Text(
          trans(context, "title_big_book"),
        ),
      ),
      fab: _disclaimer
          ? Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.vertical,
              child: Dismissible(
                key: UniqueKey(),
                child: FloatingActionButton.extended(
                  onPressed: () => setState(() => _disclaimer = false),
                  label: Text(
                    trans(context, "translation_disclaimer"),
                  ),
                  backgroundColor: Colors.red,
                  shape: Border.all(),
                ),
              ),
            )
          : null,
      child: FutureBuilder(
        future: rootBundle.loadString("assets/big_book/$lang.big.book.json"),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.done) {
            var bigBook = BigBook.fromRawJson(future.data).bigBook;
            // TODO: Fix misaligned scroll index
            return Container(
              margin: EdgeInsets.all(20),
              child: DraggableScrollbar.arrows(
                // labelTextBuilder: (double offset) => Text(
                //   "${1 + offset / 3.225 ~/ bigBook.where((t) => t.section == "Chapters").toList().length}/" +
                //       bigBook
                //           .where((t) => t.section == "Chapters")
                //           .toList()
                //           .length
                //           .toString(),
                //   style: TextStyle(color: Colors.black),
                // ),
                backgroundColor: Colors.lightBlue,
                controller: controller,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .25),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  controller: controller,
                  itemCount:
                      bigBook.where((t) => t.section == "Chapters").length,
                  itemBuilder: (context, index) {
                    return AutoScrollTag(
                      highlightColor: Colors.green,
                      key: ValueKey(index),
                      controller: controller,
                      index: index,
                      child: Container(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Column(
                            children: <Widget>[
                              Text(
                                bigBook
                                    .where((t) => t.section == "Chapters")
                                    .toList()[index]
                                    .pageNumber
                                    .toString(),
                              ),
                              Text(
                                bigBook
                                    .where((t) => t.section == "Chapters")
                                    .toList()[index]
                                    .text
                                    .join(' '),
                              ),
                              Text(bigBook
                                  .where((t) => t.section == "Chapters")
                                  .toList()[index]
                                  .chapterName
                                  .toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return RefreshProgressIndicator();
        },
      ),
    );
  }
}

class BigBookChapterView extends StatelessWidget {
  final int f;

  BigBookChapterView(this.f);

  @override
  Widget build(BuildContext context) {
    var lang = (Localizations.localeOf(context).languageCode == "he")
        ? "en"
        : Localizations.localeOf(context).languageCode;
    return FutureBuilder(
      future: rootBundle.loadString("assets/big_book/$lang.big.book.json"),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.done) {
          var bigBook = BigBook.fromRawJson(future.data).bigBook;
          return MyScaffold(
            implyLeading: true,
            title: Center(
              child: Text(bigBook.first.chapterName ?? 'test'),
            ),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                children: bigBook
                    .map(
                      (x) => Text(
                        x.text.first + "\n",
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.justify,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        }
        return MyScaffold(
          child: Container(),
        );
      },
    );
  }
}
