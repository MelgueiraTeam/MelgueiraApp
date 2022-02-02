import 'package:flutter/cupertino.dart';
import 'package:melgueira_app/entidades/banco_dados/box_melgueira.dart';
import 'package:melgueira_app/entidades/banco_dados/media_box.dart';
import 'package:mysql1/mysql1.dart';

import 'alerta.dart';

class DataBase {
  static String ip = "";
  static String porta = "";
  static String usuario = "";
  static String senha = "";
  static String nomeBanco = "";

  static MySqlConnection? conn;
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

  static Future<List<MediaBox>> getDadosRelatorio(DateTime? dataInicial, DateTime? dataFinal) async {
    List<MediaBox> listaMedias = <MediaBox>[];
    String sql = "";

    if (DataBase.conn != null) {
      sql = "select * from mediaBox where dia <= '${dataFinal}' and dia >= '${dataInicial}'  order by dia asc";

      try {
        await DataBase.getConexao().then((value) async {
          await DataBase.conn!.query(sql).then((results) {
            for (var element in results) {
              MediaBox objMediaBox = MediaBox(element[0], element[1], element[2], element[3], element[4], element[5]);
              listaMedias.add(objMediaBox);
            }
          });
        }).then((value) {
          DataBase.conn!.close();
        });
        debugPrint("DataBase.getDadosRelatorio: Sucesso.");
      } catch (e) {
        debugPrint("DataBase.getDadosRelatorio: " + e.toString());
      }
    }
    return listaMedias;
  }

  static Future<List<BoxMelgueira>> getDadosTemperatura({String? idCaixa}) async {
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
          await DataBase.conn!.query(sql).then((results) {
            for (var element in results) {
              BoxMelgueira objBoxMelgueira = BoxMelgueira(element[1], element[2], element[4], element[5], 0);
              listaTemperatura.add(objBoxMelgueira);
            }
          });
        }).then((value) {
          DataBase.conn!.close();
        });
        debugPrint("DataBase.getDadosTemperatura: Sucesso.");
      } catch (e) {
        debugPrint("DataBase.getDadosTemperatura: " + e.toString());
      }
    }
    return listaTemperatura;
  }

  static Future<bool> deleteAlerta(String id) async {
    String sql = "";

    sql += "update alerts set excluido = 1, data_exclusao = now() where id = $id";

    try {
      await DataBase.getConexao().then((value) async {
        await DataBase.conn!.query(sql).then((results) {});
        debugPrint("DataBase.deleteAlerta: Sucesso ao deletar Alerta");
      }).then((value) {
        DataBase.conn!.close();
      });
      return true;
    } catch (e) {
      debugPrint("DataBase.deleteAlerta: " + e.toString());
      return false;
    }
  }

  static Future<List<Alerta>> getAlertas(String id_caixa) async {
    List<Alerta> listaAlertas = <Alerta>[];
    String sql = "";

    if (DataBase.conn != null) {
      sql = 'SELECT * FROM alerts where excluido is null and id_caixa = ${id_caixa}';
    }

    await DataBase.getConexao().then((value) async {
      await DataBase.conn!.query(sql).then((results) {
        for (var element in results) {
          Alerta objAlerta = Alerta(element[0], element[1], element[2], element[3], element[4], element[5], element[6],
              element[7], element[8], element[9]);
          listaAlertas.add(objAlerta);
        }
      });
    }).then((value) {
      DataBase.conn!.close();
    });
    debugPrint("DataBase.getAlertas : " + listaAlertas.length.toString());
    return listaAlertas;
  }

  static Future<int> getMaxIdAlerts() async {
    int maisAlto = 0;

    String sql = "";
    sql +=
        "SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${DataBase.nomeBanco.toString()}' AND TABLE_NAME = 'alerts'";

    try {
      await DataBase.getConexao().then((value) async {
        await DataBase.conn!.query(sql).then((results) {
          for (var elements in results) {
            if (elements[0] == null) {
              maisAlto = 0;
            } else {
              maisAlto = elements[0];
            }
          }
          debugPrint("DataBase.getMaxIdAlerts: " + maisAlto.toString());
        });
      }).then((value) {
        DataBase.conn!.close();
      });
    } catch (e) {
      debugPrint("DataBase.getMaxIdAlerts: " + e.toString());
      return maisAlto;
    }

    return maisAlto;
  }

  static Future<bool> saveAlerta(String descricao, double tempMin, double tempMax, String id_caixa) async {
    String sql = "";

    sql = "insert into alerts (id, descricao, tempMin, tempMax, data_Cadastro, id_caixa)";
    sql += "values (null, '$descricao', $tempMin, $tempMax, NOW(), ${id_caixa})";

    try {
      await DataBase.getConexao().then((value) async {
        await DataBase.conn!.query(sql).then((results) {});
      }).then((value) {
        DataBase.conn!.close();
      });
      return true;
    } catch (e) {
      debugPrint("DataBase.saveAlerta: " + e.toString());
      return false;
    }
  }

  static Future<bool> updateAlerta(int id, String descricao, double tempMin, double tempMax) async {
    String sql = "";

    sql = "update alerts set  descricao = '$descricao', tempMin = $tempMin, ";
    sql += " tempMax = $tempMax, data_alteracao = now() where id = $id ";

    try {
      await DataBase.getConexao().then((value) async {
        await DataBase.conn!.query(sql).then((results) {});
      }).then((value) {
        DataBase.conn!.close();
      });
      return true;
    } catch (e) {
      debugPrint("DataBase.updateAlerta: " + e.toString());
      return false;
    }
  }

  static String tString() {
    return 'DataBase{IP: ${DataBase.ip}, Porta: ${DataBase.porta}, Usuario: ${DataBase.usuario}, Senha: ${DataBase.senha}, NomeBanco: ${DataBase.nomeBanco}}';
  }
}
