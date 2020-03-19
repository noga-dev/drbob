// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:flutter_test/flutter_test.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  MockMethodChannel mockChannel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const int id = 0;
  const String title = 'title';
  const String body = 'body';
  const String payload = 'payload';
  
  test('someTest', () => null);

  group('android', () {
    setUp(() {
      mockChannel = MockMethodChannel();
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin.private(
          mockChannel, FakePlatform(operatingSystem: 'android'));
    });
    test('initialise plugin on Android', () async {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(initializationSettingsAndroid, null);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      verify(mockChannel.invokeMethod<dynamic>(
          'initialize', initializationSettingsAndroid.toMap()));
    });
    test('show notification on Android', () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              'your channel description',
              importance: Importance.Max, priority: Priority.High);

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(androidPlatformChannelSpecifics, null);

      await flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: payload);
      verify(mockChannel.invokeMethod<dynamic>('show', <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'platformSpecifics': androidPlatformChannelSpecifics.toMap(),
        'payload': payload
      }));
    });
    test('schedule notification on Android', () async {
      final DateTime scheduledNotificationDateTime =
          DateTime.now().add(const Duration(seconds: 5));

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your other channel id',
              'your other channel name', 'your other channel description');

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(androidPlatformChannelSpecifics, null);
      final Map<String, dynamic> androidPlatformChannelSpecificsMap = androidPlatformChannelSpecifics.toMap();
      androidPlatformChannelSpecificsMap['allowWhileIdle'] = false;
      await flutterLocalNotificationsPlugin.schedule(id, title, body,
          scheduledNotificationDateTime, platformChannelSpecifics);
      verify(mockChannel.invokeMethod<dynamic>('schedule', <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'millisecondsSinceEpoch':
            scheduledNotificationDateTime.millisecondsSinceEpoch,
        'platformSpecifics': androidPlatformChannelSpecificsMap,
        'payload': ''
      }));
    });

    test('delete notification on android', () async {
      await flutterLocalNotificationsPlugin.cancel(id);
      verify(mockChannel.invokeMethod<dynamic>('cancel', id));
    });
  });
}
