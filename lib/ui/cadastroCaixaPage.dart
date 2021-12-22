import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';

class CadastroCaixaPage extends StatefulWidget {
  final Caixa caixa;
  final MeliponarioHelper helper;

  const CadastroCaixaPage({this.caixa, this.helper});

  @override
  _CadastroCaixaPageState createState() => _CadastroCaixaPageState();
}

class _CadastroCaixaPageState extends State<CadastroCaixaPage> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _editado = false; //verefica se houve alteração nos dados do meliponário

  Caixa _editedCaixa;

  @override
  void initState() {
    super.initState();

    if (widget.caixa == null) {
      _editedCaixa = Caixa();
      _editedCaixa.data = gerarData();
      //_excluir = true;
    } else {
      _editedCaixa = Caixa.fromMap(widget.caixa.toMap());

      _nomeController.text = _editedCaixa.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Cadastrar Caixa"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editedCaixa.nome != null && _editedCaixa.nome.isNotEmpty) {
            Navigator.pop(context, _editedCaixa);
          } else {
            FocusScope.of(context).requestFocus(_nomeFocus);
          }
        },
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
                controller: _nomeController,
                decoration: InputDecoration(
                    labelText: "Nome Caixa",
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    border: OutlineInputBorder()),
                onChanged: (text) {
                  _editado = true;
                  setState(() {
                    _editedCaixa.nome = text;
                  });
                }),

            /*Divider(),
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
            ),*/ //fora do escopo do meu pfc
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_editado){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, child: Text("Sim"),),
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancelar"),),
              ],
            );
          }
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  String gerarData() {
    var data = DateTime.now();
    String dataFormatada;
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;

    //eu sei que é xunxu
    //no futuro usar plugins para formatar no padrão PT-BR

    if (dia < 10) {
      dataFormatada = "0$dia/";
    } else {
      dataFormatada = "$dia/";
    }

    if (mes < 10) {
      dataFormatada += "0$mes/";
    } else {
      dataFormatada += "$mes/";
    }
    dataFormatada += "$ano";
    return dataFormatada;
  }
}
