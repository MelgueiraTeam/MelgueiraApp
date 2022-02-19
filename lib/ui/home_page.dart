import 'package:flutter/material.dart';
import 'package:melgueira_app/ui/meliponarios_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TelaMeliponarios(),
    );
  }
}
