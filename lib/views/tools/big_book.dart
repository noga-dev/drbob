import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/models/big_book.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BigBookView extends StatefulWidget {
  @override
  _BigBookViewState createState() => _BigBookViewState();
}

class _BigBookViewState extends State<BigBookView> {
  AutoScrollController controller;
  bool _disclaimer;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final double _fontSize =
        Provider.of<Bloc>(context).getPrefs.containsKey('fontSize')
            ? Provider.of<Bloc>(context).getPrefs.getDouble('fontSize')
            : 12;
    // TODO(AN): Implement translations
    final String lang = (Localizations.localeOf(context).languageCode == 'en')
        ? Localizations.localeOf(context).languageCode
        : 'en';
    _disclaimer = Localizations.localeOf(context).languageCode == 'en';
    return MyScaffold(
      implyLeading: true,
      title: Center(
        child: Text(trans(context, 'title_big_book')),
      ),
      fab: _disclaimer
          ? null
          : Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.vertical,
              child: Dismissible(
                key: UniqueKey(),
                child: FloatingActionButton.extended(
                  onPressed: () => setState(() => _disclaimer = false),
                  label: Text(
                    trans(context, 'translation_disclaimer'),
                  ),
                  backgroundColor: Colors.red,
                  shape: Border.all(),
                ),
              ),
            ),
      child: FutureBuilder<dynamic>(
        future: rootBundle.loadString('assets/big_book/$lang.big.book.json'),
        builder: (BuildContext context, AsyncSnapshot<dynamic> future) {
          if (future.connectionState == ConnectionState.done) {
            final List<BigBookPage> bigBook =
                BigBook.fromRawJson(future.data.toString()).bigBook;
            // TODO(AN): Fix misaligned scroll index
            return DraggableScrollbar.semicircle(
              heightScrollThumb: 60,
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
                separatorBuilder: (BuildContext context, int index) =>
                    Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25,
                    vertical: 5,
                  ),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                controller: controller,
                itemCount: bigBook
                    .where((BigBookPage t) => t.section == 'Chapters')
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return AutoScrollTag(
                    highlightColor: Colors.green,
                    key: ValueKey<int>(index),
                    controller: controller,
                    index: index,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: <Widget>[
                            Text(
                              bigBook
                                  .where((BigBookPage t) =>
                                      t.section == 'Chapters')
                                  .toList()[index]
                                  .chapterName
                                  .toString(),
                              style: TextStyle(fontSize: _fontSize + 4),
                              textAlign: TextAlign.center,
                            ),
                            const Divider(),
                            SelectableText(
                              bigBook
                                  .where((BigBookPage t) =>
                                      t.section == 'Chapters')
                                  .toList()[index]
                                  .text
                                  .join(' '),
                              style: TextStyle(fontSize: _fontSize),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              bigBook
                                  .where((BigBookPage t) =>
                                      t.section == 'Chapters')
                                  .toList()[index]
                                  .pageNumber
                                  .toString(),
                              style: TextStyle(fontSize: _fontSize - 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: RefreshProgressIndicator());
        },
      ),
    );
  }
}

class BigBookChapterView extends StatelessWidget {
  const BigBookChapterView(this.f);

  final int f;

  @override
  Widget build(BuildContext context) {
    final String lang = (Localizations.localeOf(context).languageCode == 'he')
        ? 'en'
        : Localizations.localeOf(context).languageCode;
    return FutureBuilder<dynamic>(
      future: rootBundle.loadString('assets/big_book/$lang.big.book.json'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> future) {
        if (future.connectionState == ConnectionState.done) {
          final List<BigBookPage> bigBook =
              BigBook.fromRawJson(future.data.toString()).bigBook;
          return MyScaffold(
            implyLeading: true,
            title: Center(
              child: Text(bigBook.first.chapterName ?? 'test'),
            ),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                children: bigBook
                    .map(
                      (BigBookPage x) => Text(
                        x.text.first + '\n',
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
