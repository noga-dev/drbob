import 'dart:convert';

class DailyReflection {
  DailyReflection({
    this.month,
    this.day,
    this.title,
    this.excerpt,
    this.source,
    this.reflection,
  });

    factory DailyReflection.fromRawJson(String str) => DailyReflection.fromJson(
    //ignore: argument_type_not_assignable
        json.decode(str),
      );

        factory DailyReflection.fromJson(Map<String, dynamic> json) =>
      DailyReflection(
        //ignore: argument_type_not_assignable
        month: json['month'],
        //ignore: argument_type_not_assignable
        day: json['day'],
        //ignore: argument_type_not_assignable
        title: json['title'],
        //ignore: argument_type_not_assignable
        excerpt: json['excerpt'],
        //ignore: argument_type_not_assignable
        source: json['source'],
        //ignore: argument_type_not_assignable
        reflection: json['reflection'],
      );

  int month;
  int day;
  String title;
  String excerpt;
  String source;
  String reflection;

  static List<DailyReflection> fromJson2List(String str) =>
      List<DailyReflection>.from(
        //ignore: argument_type_not_assignable
        json.decode(str).map(
              //ignore: argument_type_not_assignable
              (dynamic x) => DailyReflection.fromJson(x),
            ),
      );

  String fromList2Json(List<DailyReflection> data) => json.encode(
        List<dynamic>.from(
          //ignore: implicit_dynamic_method
          data.map(
            (dynamic x) => x.toJson(),
          ),
        ),
      );

  String toRawJson() => json.encode(toJson());

  //ignore: implicit_dynamic_map_literal
  Map<String, dynamic> toJson() => <String, dynamic>{
        'month': month,
        'day': day,
        'title': title,
        'excerpt': excerpt,
        'source': source,
        'reflection': reflection,
      };
}
