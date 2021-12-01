import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/meliponariosPage.dart';
import 'package:prototipo_01/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          drawer: CustomDrawer(),
          body: TelaMeliponarios(),
        )
      ],
    );
  }
}
