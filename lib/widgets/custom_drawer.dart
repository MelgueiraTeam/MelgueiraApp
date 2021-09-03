import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 230, 92, 0),//#e65c00
              Color.fromARGB(255, 249, 212, 35),//#F9D423
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      ),
    );
    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
        ],
      ),
    );
  }
}
