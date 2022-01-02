import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';

class DetalhesCaixaPage extends StatefulWidget {
  final Caixa caixa;

  DetalhesCaixaPage({this.caixa});

  @override
  _DetalhesCaixaPageState createState() => _DetalhesCaixaPageState();
}

class _DetalhesCaixaPageState extends State<DetalhesCaixaPage> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Detalhes Caixa01"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 255, 166, 78),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Coletas",
                ),
                Tab(
                  text: "Detalhes",
                ),
                Tab(
                  text: "Alimentações",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(),
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                          image: DecorationImage(
                              image: widget.caixa.image != null ?
                              FileImage(File(widget.caixa.image)) :
                              AssetImage("images/person.png")
                          )
                      ),
                    ),
                  )
                ],
              ),
              Container(),
            ],
          ),
        )
    );
  }
  Widget _criarCartaoColeta(String data, double quantidade){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "data: $data",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "quantidade: $quantidade Kg",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
