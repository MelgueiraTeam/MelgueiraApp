// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prototipo_01/helpers/dataBase.dart';

String leitura = "";

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key key}) : super(key: key);

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  static TextEditingController tecIp = TextEditingController();
  static TextEditingController tecPorta = TextEditingController();
  static TextEditingController tecUsuario = TextEditingController();
  static TextEditingController tecSenha = TextEditingController();
  static TextEditingController tecBanco = TextEditingController();

  static MySqlConnection conexao;
  static bool statusConexao = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Banco de Dados",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: tecIp,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                      fillColor: Colors.blue,
                                      label: Text(
                                        "Endereço IP:",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: tecPorta,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                      label: Text(
                                        "Porta:",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      border: OutlineInputBorder(),
                                      hoverColor: Colors.blue),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: tecBanco,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                      label: Text(
                                        "Nome do Banco:",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      border: OutlineInputBorder(),
                                      hoverColor: Colors.blue),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: tecUsuario,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                      label: Text(
                                        "Usuario:",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: tecSenha,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Senha:",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 8.0, 10, 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {



                                        DataBase.objBanco = DataBase.name(
                                            tecIp.text,
                                            tecPorta.text,
                                            tecUsuario.text,
                                            tecSenha.text,
                                            tecBanco.text);
                                        _saveData(DataBase.objBanco.toJson());

                                        setState(() {
                                          tentaConectar().then((value) {
                                            showDialog<void>(
                                                context: context, // user must tap button!
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: const Text('Conexão com Banco de Dados:'),
                                                  content: SingleChildScrollView(
                                                  child: ListBody(
                                                  children: <Widget>[
                                                    Text(value ? "Sucesso ao conectar no banco de dados!" : "Erro ao conectar no banco de dados: " + DataBase.objBanco.erroConexa),

                                                  ],
                                                  ),
                                                  ),
                                                  );
                                                }
                                            );

                                          });


                                        });
                                      },
                                      child: Text("Conectar")),
                                ),
                              ),
                            ],
                          ),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                elevation: 10,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ));
  }





  Future salvarDados(Map<String, dynamic> stringJson) async {
    await _saveData(stringJson);
  }

  Future<File> _saveData(Map<String, dynamic> stringJson) async {
    String data = json.encode(stringJson);

    final file = await _getFile();

    return file.writeAsString(data);
  }
  

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return "erro";
    }
  }

  Future<bool> tentaConectar() async {
    statusConexao = await DataBase.objBanco.testaConexao();
    
    return Future.value(statusConexao);

  }

  Future lerDados() async {
    await _readData().then((value) => leitura = value);
    Map<String, dynamic> teste = jsonDecode(leitura);
    DataBase.objBanco.AtualizaObjbanco(
        ipServidor: "",
        portaServidor: "",
        usuarioServidor: "",
        senhaServidor: "",
        banco: "");
    DataBase.objBanco = DataBase.fromJson(teste);

    tecIp.text = DataBase.objBanco.ipServidor;
    tecPorta.text = DataBase.objBanco.portaServidor;
    tecBanco.text = DataBase.objBanco.banco;
    tecUsuario.text = DataBase.objBanco.usuarioServidor;
    tecSenha.text = DataBase.objBanco.senhaServidor;
  }

  @override
  void initState() {
    super.initState();
    tecIp.text = "melgueira.com";
    tecPorta.text = "3306";
    tecUsuario.text = "melgue20_Melgueira_adm";
    tecSenha.text= "yA7Ki[uGa-P;C[=pRD";
    tecBanco.text = "melgue20_Melgueira_Box";
    lerDados();
  }
}

Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();

  return File("${directory.path}/config.json");
}


