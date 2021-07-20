import 'package:flutter/material.dart';

class CadastroCaixaPage extends StatefulWidget {
  @override
  _CadastroCaixaPageState createState() => _CadastroCaixaPageState();
}

class _CadastroCaixaPageState extends State<CadastroCaixaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Cadastrar Caixa"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: Container(
                width: 160.0,
                height: 160.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/person.png"))),
              ),
              onTap: () {}, //é preciso ter um bd para trocar a imagem
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Nome Caixa",
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  border: OutlineInputBorder()),
            ),
            Divider(),
            Text(
              "Sistema de termoregulação",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Temperatura mínima",
                          labelStyle: TextStyle(color: Colors.deepOrange),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Temperatura máxima ",
                          labelStyle: TextStyle(color: Colors.deepOrange),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
