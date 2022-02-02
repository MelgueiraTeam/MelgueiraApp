import 'package:flutter/material.dart';
import 'package:melgueira_app/entidades/themes.dart';
import 'package:melgueira_app/telas/menu/menu.dart';

import '../../entidades/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Textos.textoTituloAppBarHome,
          style: TextStyle(color: Cores.tituloBranco),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: false,
      // ignore: prefer_const_constructors
      body: Menu(),
    );
  }
}
