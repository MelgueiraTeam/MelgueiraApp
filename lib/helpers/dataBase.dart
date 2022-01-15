import 'dart:convert';

//import 'package:melgueira_app/entidades/boxMelgueira.dart';
import 'package:mysql1/mysql1.dart';

import 'boxMelgueira.dart';

class DataBase {
  String _ipServidor = "";
  String _portaServidor = "";
  String _usuarioServidor = "";
  String _senhaServidor = "";
  String _banco = "";
  String _erroConexa = "";

  String get erroConexa => _erroConexa;

  set erroConexa(String value) {
    _erroConexa = value;
  }

  static ConnectionSettings stringConexao = ConnectionSettings();
  MySqlConnection conn = null;

  bool _statusConexao = false;

  bool get statusConexao => _statusConexao;

  set statusConexao(bool value) {
    _statusConexao = value;
  }

  DataBase.fromJson(Map<String, dynamic> json)
      : _ipServidor = json['ipServidor'],
        _portaServidor = json['portaServidor'],
        _usuarioServidor = json['usuarioServidor'],
        _senhaServidor = json['senhaServidor'],
        _banco = json['banco'];

  Map<String, dynamic> toJson() => {
        'ipServidor': ipServidor,
        'portaServidor': portaServidor,
        'usuarioServidor': usuarioServidor,
        'senhaServidor': senhaServidor,
        'banco': banco
      };

  static DataBase objBanco = DataBase.name("", "", "", "", "", );

  void AtualizaObjbanco(
      { String ipServidor,
       String portaServidor,
       String usuarioServidor,
       String senhaServidor,
       String banco}) {
    objBanco._ipServidor = ipServidor;
    objBanco._portaServidor = portaServidor;
    objBanco._usuarioServidor = usuarioServidor;
    objBanco._senhaServidor = senhaServidor;
    objBanco.banco = banco;
  }

  String get ipServidor => _ipServidor;

  set ipServidor(String value) {
    _ipServidor = value;
  }

  String get banco => _banco;

  set banco(String value) {
    _banco = value;
  }

  String get senhaServidor => _senhaServidor;

  set senhaServidor(String value) {
    _senhaServidor = value;
  }

  String get usuarioServidor => _usuarioServidor;

  set usuarioServidor(String value) {
    _usuarioServidor = value;
  }

  String get portaServidor => _portaServidor;

  set portaServidor(String value) {
    _portaServidor = value;
  }

  DataBase.name(this._ipServidor, this._portaServidor, this._usuarioServidor,
      this._senhaServidor, this._banco);

  Future<MySqlConnection> geraConexao() async {
    stringConexao = ConnectionSettings(
        host: objBanco.ipServidor,
        port: int.parse(objBanco.portaServidor),
        user: objBanco.usuarioServidor,
        password: objBanco.senhaServidor,
        useSSL: false,
        db: objBanco.senhaServidor);

    try {
      conn = await MySqlConnection.connect(stringConexao);
      return conn;
    } catch (e) {
      return conn;
    }
  }

static Future<List<boxMelgueira>> pegaDadosTemperatura10()  async {
  List<boxMelgueira> listaTemperatura = <boxMelgueira>[];



      await DataBase.objBanco.conn
        .query('SELECT * FROM boxMelgueira ORDER BY id DESC LIMIT 10')
        .then((results) {
       results.forEach((element) {
         print('TemperaturaNinho: ${element[1]}!');
         print('UmidadeNinho: ${element[2]}!');

         boxMelgueira objBoxMelgueira =
         new boxMelgueira(element[1], element[2], element[4], element[5], 0);

         listaTemperatura.add(objBoxMelgueira);
       });
     });



    return listaTemperatura;
  }


  static Future<List<boxMelgueira>> pegaDadosTemperatura()  async {
    List<boxMelgueira> listaTemperatura = <boxMelgueira>[];



    await DataBase.objBanco.conn
        .query('SELECT * FROM boxMelgueira ORDER BY id DESC LIMIT 1')
        .then((results) {
      results.forEach((element) {
        print('TemperaturaNinho: ${element[1]}!');
        print('UmidadeNinho: ${element[2]}!');

        boxMelgueira objBoxMelgueira =
        new boxMelgueira(element[1], element[2], element[4], element[5], 0);

        listaTemperatura.add(objBoxMelgueira);
      });
    });



    return listaTemperatura;
  }

  Future<bool> testaConexao() async {
    stringConexao = ConnectionSettings(
        host: objBanco.ipServidor,
        port: int.parse(objBanco.portaServidor),
        user: objBanco.usuarioServidor,
        password: objBanco.senhaServidor,
        useSSL: false,
        db: objBanco.banco);

    try {
      conn = await MySqlConnection.connect(stringConexao);
      return true;
    } catch (e) {
      DataBase.objBanco.erroConexa = e.toString();
      return false;
    }
  }
}


