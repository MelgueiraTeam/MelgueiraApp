import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Teste extends StatefulWidget {
  //const Teste({Key key}) : super(key: key);

  QrPainter painter;


  Teste(this.painter);

  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,

    );
  }
}
