import 'dart:convert';

class BigBook {
    List<BigBookPage> bigBook;

    BigBook({
        this.bigBook,
    });

    factory BigBook.fromRawJson(String str) => BigBook.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BigBook.fromJson(Map<String, dynamic> json) => BigBook(
        bigBook: json["BigBook"] == null ? null : List<BigBookPage>.from(json["BigBook"].map((x) => BigBookPage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "BigBook": bigBook == null ? null : List<dynamic>.from(bigBook.map((x) => x.toJson())),
    };
}

class BigBookPage {
    String section;
    String chapterName;
    int pageNumber;
    int chapterNumber;
    List<String> text;

    BigBookPage({
        this.section,
        this.chapterName,
        this.pageNumber,
        this.chapterNumber,
        this.text,
    });

    factory BigBookPage.fromRawJson(String str) => BigBookPage.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BigBookPage.fromJson(Map<String, dynamic> json) => BigBookPage(
        section: json["Section"] == null ? null : json["Section"],
        chapterName: json["ChapterName"] == null ? null : json["ChapterName"],
        pageNumber: json["PageNumber"] == null ? null : json["PageNumber"],
        chapterNumber: json["ChapterNumber"] == null ? null : json["ChapterNumber"],
        text: json["Text"] == null ? null : List<String>.from(json["Text"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Section": section == null ? null : section,
        "ChapterName": chapterName == null ? null : chapterName,
        "PageNumber": pageNumber == null ? null : pageNumber,
        "ChapterNumber": chapterNumber == null ? null : chapterNumber,
        "Text": text == null ? null : List<dynamic>.from(text.map((x) => x)),
    };
}
