import 'package:aadr/utils/localization.dart';
import 'package:aadr/views/tools/daily_reflections.dart';
import 'package:flutter/material.dart';

class ToolsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(trans(context, "btn_daily_reflections")),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyReflectionsView(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
