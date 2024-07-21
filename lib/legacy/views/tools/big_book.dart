import 'package:drbob/legacy/blocs/bloc.dart';
import 'package:drbob/legacy/models/big_book.dart';
import 'package:drbob/legacy/utils/layout.dart';
import 'package:drbob/legacy/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BigBookView extends HookWidget {
  const BigBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSize =
        (Provider.of<Bloc>(context).getPrefs.containsKey('fontSize')
                ? Provider.of<Bloc>(context).getPrefs.getDouble('fontSize')
                : 12.0) ??
            0.0;
    // TODO(AN): Implement translations
    final lang = (Localizations.localeOf(context).languageCode == 'en')
        ? Localizations.localeOf(context).languageCode
        : 'en';

    final searchController = useTextEditingController();
    useListenable(searchController);
    final showDisclaimer =
        useState(Localizations.localeOf(context).languageCode == 'en');
    final itemScrollController = useMemoized(() => ItemScrollController());
    final itemPositionsListener =
        useMemoized(() => ItemPositionsListener.create());

    return MyScaffold(
      implyLeading: true,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: trans(
                  context,
                  'search',
                ),
                // counter: const Align(
                //   alignment: Alignment.topCenter,
                //   child: Text(
                //     'test',
                //     style: TextStyle(
                //       fontSize: 12,
                //       height: .5,
                //       color: Colors.grey,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                isDense: true,
              ),
            ),
          ),
          // const VerticalDivider(
          //   width: 26,
          // ),
          // IconButton(
          //   icon: const Icon(Icons.keyboard_arrow_up),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: const Icon(Icons.keyboard_arrow_down),
          //   onPressed: () {},
          // ),
        ],
      ),
      fab: showDisclaimer.value
          ? const SizedBox.shrink()
          : Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.vertical,
              child: Dismissible(
                key: UniqueKey(),
                child: FloatingActionButton.extended(
                  onPressed: () => showDisclaimer.value = false,
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
            final bigBook = BigBook.fromRawJson(future.data.toString()).bigBook;
            // TODO(AN): Fix misaligned scroll index
            return ScrollablePositionedList.separated(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              separatorBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .25,
                  vertical: 5,
                ),
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              itemCount: bigBook
                  .where((BigBookPage t) => t.section == 'Chapters')
                  .length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(22),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(
                      children: <Widget>[
                        Text(
                          bigBook
                              .where((BigBookPage t) => t.section == 'Chapters')
                              .toList()[index]
                              .chapterName
                              .toString(),
                          style: TextStyle(fontSize: fontSize + 4),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        SelectableText.rich(
                          TextSpan(
                            children: bigBook
                                .where(
                                    (BigBookPage t) => t.section == 'Chapters')
                                .toList()[index]
                                .text
                                .join(' ')
                                .trim()
                                // .split(RegExp(r'[ \-\u2014]'))
                                // OPTIMIZE - FINDS BAD RESULTS
                                .split(' ')
                                .map(
                                  (e) => TextSpan(
                                    children: [
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: e,
                                        style: searchController
                                                    .text.isNotEmpty &&
                                                e.toLowerCase().contains(
                                                    searchController.text
                                                        .toLowerCase())
                                            ? const TextStyle(
                                                // color: Colors.red,
                                                backgroundColor: Color.fromRGBO(
                                                    255, 36, 36, 0.462),
                                                decoration:
                                                    TextDecoration.underline,
                                              )
                                            : null,
                                      ),
                                      // if (!bigBook
                                      //     .where((BigBookPage t) =>
                                      //         t.section == 'Chapters')
                                      //     .toList()[index]
                                      //     .text
                                      //     .last
                                      //     .endsWith(e))
                                      //   const TextSpan(text: ' '),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          'p.${bigBook.where((BigBookPage t) => t.section == 'Chapters').toList()[index].pageNumber.toString()}',
                          style: TextStyle(fontSize: fontSize - 4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: RefreshProgressIndicator());
        },
      ),
    );
  }
}

class BigBookChapterView extends StatelessWidget {
  const BigBookChapterView(this.f, {super.key});

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
              child: Text(bigBook.first.chapterName),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              children: bigBook
                  .map(
                    (BigBookPage x) => Text(
                      '${x.text.first}\n',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.justify,
                    ),
                  )
                  .toList(),
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
