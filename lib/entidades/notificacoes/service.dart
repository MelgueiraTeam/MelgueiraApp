import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class Service {
  static final Service _notificationService = Service._internal();

  factory Service() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Service._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_melgueira_app');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future showNotification(int id, String title, String body) async {

    flutterLocalNotificationsPlugin.show(id, title, body, const NotificationDetails(
      android: AndroidNotificationDetails(
          'Main Channel',
          'Main channel notifications',
          styleInformation: BigTextStyleInformation(''),
          importance: Importance.max,
          priority: Priority.max,
          icon: 'ic_melgueira_app'
      ),
      iOS: IOSNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}