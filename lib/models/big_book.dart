import 'dart:convert';

class BigBook {
  Map<String, List<String>> chapter;

  BigBook({
    this.chapter,
  });

  factory BigBook.fromRawJson(String str) => BigBook.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BigBook.fromJson(Map<String, dynamic> json) => new BigBook(
        chapter: new Map.from(json["chapter"]).map(
          (k, v) => new MapEntry<String, List<String>>(
            k,
            new List<String>.from(
              v.map((x) => x),
            ),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "chapter": new Map.from(chapter).map(
          (k, v) => new MapEntry<String, dynamic>(
            k,
            new List<dynamic>.from(
              v.map((x) => x),
            ),
          ),
        ),
      };
}
