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
        json.decode(str) as Map<String, dynamic>,
      );

        factory DailyReflection.fromJson(Map<String, dynamic> json) =>
      DailyReflection(
        month: json['month'] as int,
        day: json['day'] as int,
        title: json['title'] as String,
        excerpt: json['excerpt'] as String,
        source: json['source'] as String,
        reflection: json['reflection'] as String,
      );

  int month;
  int day;
  String title;
  String excerpt;
  String source;
  String reflection;

  static List<DailyReflection> fromJson2List(String str) =>
      List<DailyReflection>.from(
        json.decode(str).map(
              (dynamic x) => DailyReflection.fromJson(x as Map<String, dynamic>),
            ) as Iterable<dynamic>,
      );

  String fromList2Json(List<DailyReflection> data) => json.encode(
        List<dynamic>.from(
          data.map<dynamic>(
            (dynamic x) => x.toJson(),
          ),
        ),
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'month': month,
        'day': day,
        'title': title,
        'excerpt': excerpt,
        'source': source,
        'reflection': reflection,
      };
}
