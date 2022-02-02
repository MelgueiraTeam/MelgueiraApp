import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';

import 'box_melgueira.dart';

class DataBase {
  static String ip = "";
  static String porta = "";
  static String usuario = "";
  static String senha = "";
  static String nomeBanco = "";

  static MySqlConnection conn;
  static ConnectionSettings stringConexao = ConnectionSettings();
  static String erroConexao = "";

  static Future<bool> getConexao() async {
    stringConexao = ConnectionSettings(
        host: DataBase.ip,
        port: int.parse(DataBase.porta),
        user: DataBase.usuario,
        password: DataBase.senha,
        useSSL: false,
        db: DataBase.nomeBanco);
    try {
      conn = await MySqlConnection.connect(stringConexao);
      debugPrint("DataBase.getConexao: true");

      return true;
    } catch (e) {
      debugPrint("DataBase.getConexao: false");
      DataBase.erroConexao = e.toString();
      return false;
    }
  }

  static Future<List<BoxMelgueira>> getDadosTemperatura({String idCaixa}) async {
    List<BoxMelgueira> listaTemperatura = <BoxMelgueira>[];
    String sql = "";
    if (DataBase.conn != null) {
      sql = 'SELECT * FROM boxMelgueira ';
      if (idCaixa != "" && idCaixa != null) {
        sql += 'WHERE id_caixa = $idCaixa ';
      }
      sql += 'ORDER BY id DESC LIMIT 1 ';

      try {
        await DataBase.getConexao().then((value) async {
          await DataBase.conn.query(sql).then((results) {
            for (var element in results) {
              BoxMelgueira objBoxMelgueira = BoxMelgueira(element[1], element[2], element[4], element[5], 0);
              listaTemperatura.add(objBoxMelgueira);
            }
          });
        }).then((value) {
          DataBase.conn.close();
        });
        debugPrint("DataBase.getDadosTemperatura: Sucesso.");
      } catch (e) {
        debugPrint("DataBase.getDadosTemperatura: " + e.toString());
      }
    }
    return listaTemperatura;
  }

  static String tString() {
    return 'DataBase{IP: ${DataBase.ip}, Porta: ${DataBase.porta}, Usuario: ${DataBase.usuario}, Senha: ${DataBase.senha}, NomeBanco: ${DataBase.nomeBanco}}';
  }
}
