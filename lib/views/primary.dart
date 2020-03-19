import 'package:drbob/blocs/Bloc.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'home/daily_reflection.dart';

// TODO(AN): Replace card groups with tabs

class PrimaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Bloc>(context).flnp.initialize(
          const InitializationSettings(
            AndroidInitializationSettings('@mipmap/ic_launcher'),
            IOSInitializationSettings(),
          ),
          onSelectNotification: (String payload) => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => DailyReflectionView(
                month: DateTime.now().month,
                day: DateTime.now().day,
              ),
            ),
          ),
        );

    return MyScaffold(
      title: Center(
        child: Text(
          trans(context, 'title_home'),
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
        ),
      ),
      child: HomeView(),
      fab: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DailyReflectionView(
              month: DateTime.now().month,
              day: DateTime.now().day,
            ),
          ),
        ),
        label: Text(
          trans(context, 'btn_todays_reflection'),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
