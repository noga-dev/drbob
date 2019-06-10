import 'package:aadr/blocs/Bloc.dart';
import 'package:aadr/models/daily_reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DailyReflectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).size.height * 0.25;
    return FutureBuilder(
      future: rootBundle.loadString(
          "assets/daily_reflections/${Provider.of<Bloc>(context).getLocale.languageCode}.daily.reflections.json"),
      builder: (_, s) {
        if (s.hasData) {
          var dr = (DailyReflection.fromJson2List(s.data.toString())
                  as List<DailyReflection>)
              .firstWhere((x) =>
                  x.day == DateTime.now().day &&
                  x.month == DateTime.now().month);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                dr.title,
                softWrap: true,
                textAlign: TextAlign.justify,
                maxLines: 2,
              ),
            ),
            body: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 10.0),
                        height: topPadding,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/images/bg_beach.jpg"),
                            fit: BoxFit.fill,
                          ),
                        )),
                    Container(
                      height: topPadding,
                      padding: EdgeInsets.all(40.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(.25)),
                      child: Center(
                        //ANCHOR: Add Quote BG
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.75),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: RichText(
                            text: TextSpan(
                              text: dr.excerpt,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                              children: [
                                TextSpan(
                                  text: "\n\n",
                                  children: [
                                    TextSpan(text: dr.source),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        dr.reflection,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
