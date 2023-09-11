import 'dart:convert';

class BigBook {
  BigBook({
    required this.bigBook,
  });

  factory BigBook.fromJson(Map<String, dynamic> json) => BigBook(
        bigBook: json['BigBook'] == null
            ? <BigBookPage>[]
            : List<BigBookPage>.from(
                json['BigBook'].map(
                  (dynamic x) =>
                      BigBookPage.fromJson(x as Map<String, dynamic>),
                ) as Iterable<dynamic>,
              ),
      );

  factory BigBook.fromRawJson(String str) =>
      BigBook.fromJson(json.decode(str) as Map<String, dynamic>);

  List<BigBookPage> bigBook;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'BigBook': List<dynamic>.from(
          bigBook.map<dynamic>(
            (dynamic x) => x.toJson(),
          ),
        ),
      };
}

class BigBookPage {
  BigBookPage({
    required this.section,
    required this.chapterName,
    required this.pageNumber,
    required this.chapterNumber,
    required this.text,
  });

  factory BigBookPage.fromRawJson(String str) =>
      BigBookPage.fromJson(json.decode(str) as Map<String, dynamic>);

  factory BigBookPage.fromJson(Map<String, dynamic> json) => BigBookPage(
        section: json['Section'] as String,
        chapterName: json['ChapterName'] as String,
        pageNumber: json['PageNumber'] as int,
        chapterNumber: json['ChapterNumber'] as int,
        text: json['Text'] == null
            ? <String>[]
            : List<String>.from(
                json['Text'].map((dynamic x) => x) as Iterable<dynamic>,
              ),
      );

  String section;
  String chapterName;
  int pageNumber;
  int chapterNumber;
  List<String> text;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Section': section,
        'ChapterName': chapterName,
        'PageNumber': pageNumber,
        'ChapterNumber': chapterNumber,
        'Text': List<dynamic>.from(text.map<dynamic>((String x) => x)),
      };
}
