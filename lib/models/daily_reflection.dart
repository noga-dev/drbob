// To parse this JSON data, do
//
//     final dailyReflection = dailyReflectionFromJson(jsonString);

import 'dart:convert';

class DailyReflection {
    int month;
    int day;
    String title;
    String excerpt;
    String source;
    String reflection;

    DailyReflection({
        this.month,
        this.day,
        this.title,
        this.excerpt,
        this.source,
        this.reflection,
    });

    static fromJson2List(String str) => new List<DailyReflection>.from(json.decode(str).map((x) => DailyReflection.fromJson(x)));

    String fromList2Json(List<DailyReflection> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


    factory DailyReflection.fromRawJson(String str) => DailyReflection.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DailyReflection.fromJson(Map<String, dynamic> json) => new DailyReflection(
        month: json["month"],
        day: json["day"],
        title: json["title"],
        excerpt: json["excerpt"],
        source: json["source"],
        reflection: json["reflection"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "day": day,
        "title": title,
        "excerpt": excerpt,
        "source": source,
        "reflection": reflection,
    };
}
