import 'dart:convert';

class BigBook {
  BigBook({
    this.bigBook,
  });

  factory BigBook.fromJson(Map<String, dynamic> json) => BigBook(
        //ignore: argument_type_not_assignable
        bigBook: json['BigBook'] == null
            ? null
            : List<BigBookPage>.from(
                //ignore: argument_type_not_assignable
                json['BigBook'].map(
                  //ignore: argument_type_not_assignable
                  (dynamic x) => BigBookPage.fromJson(x),
                ),
              ),
      );

  //ignore: argument_type_not_assignable
  factory BigBook.fromRawJson(String str) => BigBook.fromJson(json.decode(str));

  List<BigBookPage> bigBook;

  String toRawJson() => json.encode(toJson());

//ignore: implicit_dynamic_map_literal
  Map<String, dynamic> toJson() => <String, dynamic>{
        'BigBook': bigBook == null
            ? null
            : List<dynamic>.from(
                //ignore: implicit_dynamic_method
                bigBook.map(
                  (dynamic x) => x.toJson(),
                ),
              ),
      };
}

class BigBookPage {
  BigBookPage({
    this.section,
    this.chapterName,
    this.pageNumber,
    this.chapterNumber,
    this.text,
  });

  factory BigBookPage.fromRawJson(String str) =>
      //ignore: argument_type_not_assignable
      BigBookPage.fromJson(json.decode(str));

  factory BigBookPage.fromJson(Map<String, dynamic> json) => BigBookPage(
        //ignore: argument_type_not_assignable
        section: json['Section'],
        //ignore: argument_type_not_assignable
        chapterName: json['ChapterName'],
        //ignore: argument_type_not_assignable
        pageNumber: json['PageNumber'],
        //ignore: argument_type_not_assignable
        chapterNumber:
            json['ChapterNumber'],
        text: json['Text'] == null
            ? null
            : List<String>.from(
                //ignore: argument_type_not_assignable
                json['Text'].map((dynamic x) => x),
              ),
      );

  String section;
  String chapterName;
  int pageNumber;
  int chapterNumber;
  List<String> text;

  String toRawJson() => json.encode(toJson());

  //ignore: implicit_dynamic_map_literal
  Map<String, dynamic> toJson() => <String, dynamic>{
        'Section': section,
        'ChapterName': chapterName,
        'PageNumber': pageNumber,
        'ChapterNumber': chapterNumber,
        //ignore: implicit_dynamic_method
        'Text': text == null ? null : List<dynamic>.from(text.map((String x) => x)),
      };
}
