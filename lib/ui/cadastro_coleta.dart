import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';

class CadastroColeta extends StatefulWidget {
  final int idCaixa;

  CadastroColeta({this.idCaixa});

  @override
  _CadastroColetaState createState() => _CadastroColetaState();
}

class _CadastroColetaState extends State<CadastroColeta> {
  final _qtdController = TextEditingController();
  final _qtdFocus = FocusNode();
  Coleta _editedColeta;

  @override
  void initState() {
    super.initState();

    if (_editedColeta == null) {
      _editedColeta = Coleta();
      _editedColeta.data = gerarData();
      _editedColeta.idCaixa = widget.idCaixa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar nova coleta"),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _qtdController,
          decoration: InputDecoration(
            labelText: "Peso coleta (Em kg)",
            labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
            border: OutlineInputBorder(),
          ),
          onChanged: (text) {
            setState(() {
              _editedColeta.quantidade = double.parse(text);
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editedColeta.quantidade != null) {
            Navigator.pop(context, _editedColeta);
          } else {
            FocusScope.of(context).requestFocus(_qtdFocus);
          }
        },
        child: Icon(Icons.save),
      ),
    );
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
