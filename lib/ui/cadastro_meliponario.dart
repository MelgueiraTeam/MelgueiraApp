import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'configuracoes.dart';
//import 'package:image_picker/image_picker.dart';

class CadastroMeliponarioPage extends StatefulWidget {
  final Meliponario? meliponario;
  final MeliponarioHelper? helper;
  final int? cultivo;

  const CadastroMeliponarioPage({Key? key, this.meliponario, this.helper, this.cultivo}) : super(key: key);

  @override
  _CadastroMeliponarioPageState createState() => _CadastroMeliponarioPageState();
}

class _CadastroMeliponarioPageState extends State<CadastroMeliponarioPage> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _editado = false; //verefica se houve alteração nos dados do meliponário

  Meliponario? _editedMeliponario;

  @override
  void initState() {
    super.initState();

    if (widget.meliponario == null) {
      _editedMeliponario = Meliponario();
      _editedMeliponario!.data = gerarData();
      _editedMeliponario!.cultivo = widget.cultivo;
    } else {
      _editedMeliponario = Meliponario.fromMap(widget.meliponario!.toMap());

      _nomeController.text = _editedMeliponario!.nome!;
      _descricaoController.text = _editedMeliponario!.descricao!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 166, 78),
            title: Text(_editedMeliponario!.nome ?? "Novo Apiário"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedMeliponario!.nome != null &&
                  _editedMeliponario!.nome!.isNotEmpty &&
                  _editedMeliponario!.descricao != null &&
                  _editedMeliponario!.descricao!.isNotEmpty) {
                Navigator.pop(context, _editedMeliponario);
              } else {
                FocusScope.of(context).requestFocus(_nomeFocus);
              }
            },
            child: const Icon(Icons.save),
            backgroundColor: const Color.fromARGB(255, 255, 166, 78),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _editedMeliponario!.image != null
                                  ? FileImage(File(_editedMeliponario!.image!))
                                  : const AssetImage("images/person.png") as ImageProvider)),
                    ),
                  ),
                  onTap: () {
                    var picker = ImagePicker();
                    picker.pickImage(source: ImageSource.camera).then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedMeliponario!.image = file.path;
                      });
                    });
                  }, //é preciso ter um bd para trocar a imagem
                ),
                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: const InputDecoration(
                      labelText: "Nome Meliponário",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                      border: OutlineInputBorder()),
                  onChanged: (text) {
                    _editado = true;
                    setState(() {
                      _editedMeliponario!.nome = text;
                    });
                  },
                ),
                const Divider(),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                      labelText: "Descrição Meliponário",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                      border: OutlineInputBorder()),
                  onChanged: (text) {
                    _editado = true;
                    _editedMeliponario!.descricao = text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () async {
                        //Implementar exclusão
                        if(widget.meliponario != null) {
                          await widget.helper!.deleteMeliponario(widget.meliponario!.id!).then((value) async {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        _showQrConfigsConexao();
                      },
                      child: const Text(
                        "Configurar conexão",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      //color: !_excluir ? Colors.red : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_editado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar alterações?"),
              content: const Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Sim"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  ///método responsável por pegar data atual do sistema e formata-la no padrão brasileiro
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

  void _showQrConfigsConexao() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Configuracoes()));
  }
}
