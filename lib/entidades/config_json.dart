import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'banco_dados/data_base.dart';

class ConfigJson {
  static String idCaixa = "";

  static void fromJson(Map<String, dynamic> json) {
    DataBase.ip = json['IP'];
    DataBase.porta = json['Porta'];
    DataBase.usuario = json['Usuario'];
    DataBase.senha = json['Senha'];
    DataBase.nomeBanco = json['NomeBanco'];
    ConfigJson.idCaixa = json['idCaixa'];
  }

  static Map<String, dynamic> toJson() => {
        'IP': DataBase.ip,
        'Porta': DataBase.porta,
        'Usuario': DataBase.usuario,
        'Senha': DataBase.senha,
        'NomeBanco': DataBase.nomeBanco,
        'idCaixa': ConfigJson.idCaixa
      };

  static Future readConfigJson({bool gerarConexaoBanco = false}) async {
    Map<String, dynamic>? configJson;

    await ConfigJson.readData().then((value) async {
      try {
        configJson = jsonDecode(value);
        ConfigJson.fromJson(configJson!);

        debugPrint("DataBase.tString: " + DataBase.tString());
        debugPrint("ConfigJson.tString: " + ConfigJson.tString());

        if (gerarConexaoBanco) {
          await DataBase.getConexao();
        }
      } on FormatException catch (e) {
        debugPrint('ConfigJson.readData.FormatException: ${e.message}');
        if (e.message == 'Unexpected character') {
          ConfigJson.saveData(ConfigJson.toJson());
        }
      }
    });
  }

  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    debugPrint("ConfigJson.getFile: ${directory.path.toString()}/config.json");
    return File("${directory.path}/config.json");
  }

  static Future<String> readData() async {
    try {
      final file = await getFile();
      debugPrint("ConfigJson.readData: ${await file.readAsString().then((value) => value.toString())}");
      return file.readAsString();
    } catch (e) {
      return "erro";
    }
  }

  static Future<File> saveData(Map<String, dynamic> stringJson) async {
    String data = json.encode(stringJson);

    final file = await getFile();

    debugPrint("ConfigJson.saveData: $data");

    return file.writeAsString(data);
  }

  static String tString() {
    return 'ConfigJson{IdMelgueiraBox: ${ConfigJson.idCaixa}}';
  }
}
