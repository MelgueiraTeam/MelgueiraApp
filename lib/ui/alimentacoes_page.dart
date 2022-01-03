import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/cadastro_alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {

  @override
  _AlimentacaoPageState createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroAliementacaoPage,
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          _createCardAlimentacao("10", "01/01/2022", "enérgica"),
          _createCardAlimentacao("07", "01/01/2021", "protéica"),
          _createCardAlimentacao("10", "01/01/2022", "enérgica"),
          _createCardAlimentacao("07", "01/01/2021", "protéica"),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _createCardAlimentacao("10", "01/01/2022", "enérgica"),
            ),
          ),
          _createCardAlimentacao("07", "01/01/2021", "protéica"),
        ],
      ),
    );;
  }

  Widget _createCardAlimentacao(String qtd, String data, String tipo) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alimentação dia: " + data,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(qtd + "Kg",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(tipo,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showCadastroAliementacaoPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroAlimentacao()));
  }

}
