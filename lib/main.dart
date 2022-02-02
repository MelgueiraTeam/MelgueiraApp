import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prototipo_01/ui/homePage.dart';
import 'package:prototipo_01/ui/notifications_service.dart';

void main(){

  Notificacoes a = Notificacoes();
  a.init();

  runApp(MaterialApp(
    home: LogoApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class LogoApp extends StatefulWidget {
  const LogoApp({Key key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;


  @override
  void initState() {
    super.initState();

    void init() {
      final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon');

      final InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: null,
          macOS: null);
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 0.0, end: 300.0).animate(controller);
    animation.addListener(() {
      setState(() {

      });
    });

    controller.forward();

    controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=>HomePage())
          );
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: animation.value,
              width: animation.value,
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/logo.png")
                    )
                ),
              ),
            ),
            Text("Um aplicativo para gerenciar cultivos de \nabelha e sua produção de mel",
              style: TextStyle(fontSize: 19 * controller.value, fontWeight: FontWeight.bold,),
            )
          ],
        ),
      ),
    );

}

}
