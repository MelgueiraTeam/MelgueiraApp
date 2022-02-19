import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificacoes{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  init() async{
    WidgetsFlutterBinding.ensureInitialized();

    var inicializationsSettingsAndroid = const AndroidInitializationSettings('icon');

    var inicializationSettings = InitializationSettings(
        android: inicializationsSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(inicializationSettings);

    notificar();
  }

  void notificar() async{

    var schedulerNotificationDataTime = DateTime.now().add(const Duration(seconds: 10));

    var androidPlataformChannelSpecifics = const AndroidNotificationDetails(
      "alarm_notif",
      "alarm_notif",
      channelDescription: "asdasd",
      icon: 'icon',
    );

    var platformChannelSpcifics = NotificationDetails(android: androidPlataformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, "Caixas prontas para a coleta", "Essa é a época ideal para fazer as coletas de suas caixas", schedulerNotificationDataTime, platformChannelSpcifics);
  }
}