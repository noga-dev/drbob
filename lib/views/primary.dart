import 'package:drbob/blocs/bloc.dart';
import 'package:drbob/utils/layout.dart';
import 'package:drbob/utils/localization.dart';
import 'package:drbob/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'home/daily_reflection.dart';

class PrimaryView extends StatelessWidget {
  const PrimaryView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Bloc>(context).flnp.initialize(
          const InitializationSettings(),
          onDidReceiveNotificationResponse: (NotificationResponse details) =>
              Navigator.push(
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
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
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
      child: const HomeView(),
    );
  }
}
