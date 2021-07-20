import 'package:flutter/material.dart';

class DetalhesCaixaPage extends StatefulWidget {
  @override
  _DetalhesCaixaPageState createState() => _DetalhesCaixaPageState();
}

class _DetalhesCaixaPageState extends State<DetalhesCaixaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes Caixa01"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: "Cadastrar Coleta",
                            labelStyle: TextStyle(color: Colors.deepOrange),
                            ),
                      ),
                    ),
                    RaisedButton(
                      child: Text(
                          "Add"
                      ),
                      color: Colors.blue,
                      onPressed: (){},
                    )
                  ],
                ),
              ),
              Container(
                width: 160.0,
                height: 160.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/person.png"))),
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
              _criarCartaoColeta("27/11/2020", 7.0),
            ],

          ),
        ],
      ),
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
