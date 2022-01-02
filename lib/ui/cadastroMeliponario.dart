import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
//import 'package:image_picker/image_picker.dart';

class CadastroMeliponarioPage extends StatefulWidget {

  final Meliponario meliponario;
  final MeliponarioHelper helper;

  CadastroMeliponarioPage({this.meliponario, this.helper});

  @override
  _CadastroMeliponarioPageState createState() => _CadastroMeliponarioPageState();
}

class _CadastroMeliponarioPageState extends State<CadastroMeliponarioPage> {

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _editado = false;//verefica se houve alteração nos dados do meliponário
  bool _excluir = false;

  Meliponario _editedMeliponario;

  @override
  void initState() {
    super.initState();

    if(widget.meliponario == null){
      _editedMeliponario = Meliponario();
      _editedMeliponario.data = gerarData();
      _excluir = true;
    }else{
      _editedMeliponario = Meliponario.fromMap(widget.meliponario.toMap());

      _nomeController.text = _editedMeliponario.nome;
      _descricaoController.text = _editedMeliponario.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
        title: Text(_editedMeliponario.nome?? "Novo meliponário"),
        centerTitle: true,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //melhorar validação
          if(_editedMeliponario.nome != null && _editedMeliponario.nome.isNotEmpty){
            Navigator.pop(context, _editedMeliponario);
          }else{
            FocusScope.of(context).requestFocus(_nomeFocus);
          }

        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(
                      //shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedMeliponario.image != null ?
                          FileImage(File(_editedMeliponario.image)) :
                          AssetImage("images/person.png"))),
                ) ,
              ),
              onTap: (){
                var picker = ImagePicker();
                picker.getImage(source: ImageSource.camera).then((file){
                  if(file == null)return;
                  setState(() {
                    _editedMeliponario.image = file.path;
                  });
                });
              },
            ),
            TextField(
              controller: _nomeController,
              focusNode: _nomeFocus,
              decoration: InputDecoration(
                  labelText: "Nome Meliponário",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                  border: OutlineInputBorder()
              ),
              onChanged: (text){
                _editado = true;
                setState(() {
                  _editedMeliponario.nome = text;
                });
              },
            ),
            Divider(),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                  labelText: "Descrição Meliponário",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                  border: OutlineInputBorder()
              ),
              onChanged: (text){
                _editado = true;
                _editedMeliponario.descricao = text;
              },
            ),
            /*CheckboxListTile(//famoso xunxo
              title: Text("Sistema de termoregualção"),
              value: false,
              onChanged: (c){
                print(c);
              },
            ),
            CheckboxListTile(//famoso xunxo
              title: Text("Pesquisa por QR code"),
              value: false,
              onChanged: (c){
                print(c);
              },
            )*/
            Padding(padding: EdgeInsets.only(top: 10.0),
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: (){
                    //if(_excluir) {
                      widget.helper.deleteMeliponario(widget.meliponario.id);
                      Navigator.pop(context);
                    //}
                  },
                  child: Text("Excluir",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  color: !_excluir?
                  Colors.red :
                  Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    ), onWillPop: _requestPop);
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
  /// método responsável por pegar data atual do sistema e formata-la no padrão brasileiro
  String gerarData(){

    var data = DateTime.now();
    String dataFormatada;
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;

    //eu sei que é xunxu
    //no futuro usar plugins para formatar no padrão PT-BR

    if(dia < 10){
      dataFormatada = "0$dia/";
    }else{
      dataFormatada = "$dia/";
    }

    if(mes < 10){
      dataFormatada += "0$mes/";
    }else{
      dataFormatada += "$mes/";
    }
    dataFormatada += "$ano";
    return dataFormatada;
  }

}
