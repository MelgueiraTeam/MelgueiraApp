import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/homePage.dart';

void main() {
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
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: 0.0, end: 300.0).animate(controller);
    animation.addListener(() {
      setState(() {

      });
    });

    controller.forward();

    controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>HomePage())
        );
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
    return Center(
      child: Container(
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
          //child: Text("Um aplicativo para gerenciar cultivos e sua produção de mel"),
        ),
      ),
    );
  }
}

