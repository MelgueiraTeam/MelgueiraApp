import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/coletas_page.dart';

import 'alimentacoes_page.dart';

class DetalhesCaixaPage extends StatefulWidget {
  Caixa caixa;

  DetalhesCaixaPage({this.caixa});

  @override
  _DetalhesCaixaPageState createState() => _DetalhesCaixaPageState();
}

class _DetalhesCaixaPageState extends State<DetalhesCaixaPage> {

  int _tabAtual = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes " + widget.caixa.nome),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 166, 78),
          bottom: TabBar(
            onTap: (index){
              _tabAtual = index;
            },
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
            ColetasPage(idCaixa: widget.caixa.id,),
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
                            image: widget.caixa.image != null
                                ? FileImage(File(widget.caixa.image))
                                : AssetImage("images/person.png"))),
                  ),
                ),
                Text(
                  "Data de criação: " + widget.caixa.data
                )
              ],
            ),
            AlimentacaoPage(),
            /*
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Cadastrar Coleta",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Add"),
                    color: Colors.blue,
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Container(
              width: 160.0,
              height: 160.0,
              decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  image: DecorationImage(
                      image: widget.caixa.image != null
                          ? FileImage(File(widget.caixa.image))
                          : AssetImage("images/person.png"))),
            ),
            Row(
              children: [
                Text(
                  "Data de criação: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "17/11/2020",
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            Divider(),
            Text(
              "Coletas: ",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            _criarCartaoColeta("27/11/2017", 7.0),
            _criarCartaoColeta("27/11/2018", 7.0),
            _criarCartaoColeta("27/11/2019", 7.0),
            _criarCartaoColeta("27/11/2020", 7.0),*/
          ],
        ),
      ),
    );
  }

  Widget _criarCartaoColeta(String data, double quantidade) {
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
