import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastro_coleta.dart';

class ColetasPage extends StatefulWidget {

  final int idCaixa;


  ColetasPage({this.idCaixa});

  @override
  _ColetasPageState createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {

  List<Coleta> coletas = new List();
  MeliponarioHelper helper = new MeliponarioHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllColetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroColetaPage,
        child: Icon(Icons.add),
      ),
      body: coletas.length == 0? Center(
        child: Text("Nenhum Registro"),
      ) : ListView.builder(
        itemCount: coletas.length,
          itemBuilder: (context, index){
            return _createCardColeta(context, index);
          }
      ),
    );
  }

  Widget _createCardColeta(BuildContext context, int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Coleta dia: " + coletas[index].data,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(coletas[index].quantidade.toString() + "Kg",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  ///método que chama a tela de cadastro e que salva a coleta no banco de dados
  void _showCadastroColetaPage() async{

    final recColeta = await Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroColeta(idCaixa: widget.idCaixa,)));

    if(recColeta != null){
      helper.saveColeta(recColeta);
    }

    _getAllColetas();

  }

  ///método que carrega a lista com todas as coletas
  void _getAllColetas(){
    helper.getAllColetasPorCaixa(widget.idCaixa).then((list){
      setState(() {
        coletas = list;
      });
    });
  }
}
