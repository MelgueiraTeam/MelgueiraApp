import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/meliponariosPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TelaMeliponarios(),
    );
  }
}
