import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String meliponarioTable = "meliponarioTable";
const String idColumn = "idColumn";
const String nomeColumn = "nomeColumn";
const String descricaoColumn = "descricaoColumn";
const String dataColumn = "dataColumn";
const String imageColumn = "imageColumn";
const String cultivoColumn = "cultivoColumn";

const String caixaTable = "caixaTable";
const String idMeliponarioColunm = "idMeliponarioColunm";
const String valorMaximoTemperaturaColunm = "valorMaximoTemperaturaColunm";
const String valorMinimoTemperaturaColunm = "valorMinimoTemperaturaColunm";

const String coletaTable = "coletaTable";
const String quantidadeColumn = "quantidadeColumn";
const String idCaixaColumn = "idCaixaColumn";
const String anoColumn = "anoColumn";

const String alimentacaoTable = "alimentacaoTable";
const String tipoAlimentacaoColumn = "tipoAlimentacaoColumn";

class MeliponarioHelper {
  static final MeliponarioHelper _instance = MeliponarioHelper.internal();

  factory MeliponarioHelper() => _instance;

  MeliponarioHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "meliponariosnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $meliponarioTable($idColumn INTEGER PRIMARY KEY,"
          "$nomeColumn TEXT,"
          "$descricaoColumn TEXT,"
          "$dataColumn TEXT, "
          "$imageColumn TEXT,"
          "$cultivoColumn INTEGER);"

          /*
            "CREATE TABLE $caixaTable($idColumn INTEGER PRIMARY KEY,"
            "$nomeColumn TEXT,"
            "$descricaoColumn TEXT,"
            "$dataColumn DATA, "
            "$imageColumn TEXT),"
            "$idMeliponarioColunm INTEGER FOREGEIN KEY,"
            "$valorMaximoTemperaturaColunm INTEGER,"
            "$valorMinimoTemperaturaColunm INTEGER"*/
          );

      await db.execute("CREATE TABLE $caixaTable($idColumn INTEGER PRIMARY KEY,"
          "$nomeColumn TEXT,"
          "$descricaoColumn TEXT,"
          "$dataColumn TEXT,"
          "$imageColumn TEXT,"
          "$idMeliponarioColunm INTEGER,"
          "$valorMaximoTemperaturaColunm INTEGER,"
          "$valorMinimoTemperaturaColunm INTEGER);");

      await db.execute("CREATE TABLE $coletaTable($idColumn INTEGER PRIMARY KEY,"
          "$dataColumn TEXT,"
          "$quantidadeColumn REAL,"
          "$anoColumn INTEGER,"
          "$idCaixaColumn INTEGER);");

      await db.execute("CREATE TABLE $alimentacaoTable($idColumn INTEGER PRIMARY KEY,"
          "$dataColumn TEXT,"
          "$quantidadeColumn REAL,"
          "$tipoAlimentacaoColumn INTEGER,"
          "$idCaixaColumn INTEGER);");
    });
  }

  Future<Meliponario> saveMeliponario(Meliponario meliponario) async {
    //faz o insert de um meliponário no db
    Database? dbMeliponario;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.insert(meliponarioTable, meliponario.toMap()).then((value) {
        meliponario.id = value;
      });
    });

    return meliponario;
  }

  Future<Caixa> saveCaixa(Caixa caixa) async {
    //faz o insert de uma caixa no db
    Database? dbMeliponario;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.insert(caixaTable, caixa.toMap()).then((value) async {
        caixa.id = value;
      });
    });

    return caixa;
  }

  ///salva uma coleta e define seu id
  Future<Coleta> saveColeta(Coleta coleta) async {
    Database? dbMeliponario;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.insert(coletaTable, coleta.toMap()).then((value) {
        coleta.id = value;
      });
    });

    return coleta;
  }

  ///salva uma alimentação e define seu id
  Future<Alimentacao> saveAlimentacao(Alimentacao alimentacao) async {
    Database? dbMeliponario;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.insert(alimentacaoTable, alimentacao.toMap()).then((value) async {
        alimentacao.id = value;
        debugPrint("Salvo com o id: ");
        debugPrint(alimentacao.id.toString());
      });
    });
    return alimentacao;
  }

  ///faz uma query no bd por meio do id do apiário ou meliponário
  Future<Meliponario?> getMeliponario(int id) async {
    Database? dbMeliponario;
    List<Map>? maps;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .query(
        meliponarioTable,
        columns: [idColumn, nomeColumn, dataColumn, imageColumn],
        where: "$idColumn = ?",
        whereArgs: [id],
      )
          .then((value) async {
        maps = value;
      });
    });

    if (maps!.isNotEmpty) {
      return Meliponario.fromMap(maps!.first);
    } else {
      return null;
    }
  }

  ///faz uma query no bd por meio do id da caixa
  Future<Caixa?> getCaixa(int id) async {
    Database? dbMeliponario;
    List<Map>? maps;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .query(
        caixaTable,
        columns: [idColumn, nomeColumn, dataColumn, imageColumn],
        where: "$idColumn = ?",
        whereArgs: [id],
      )
          .then((value) async {
        maps = value;
      });
    });

    if (maps!.isNotEmpty) {
      return Caixa.fromMap(maps!.first);
    } else {
      return null;
    }
  }

  ///deleta um apiário e todas as suas caixas pelo id
  Future<int> deleteMeliponario(int id) async {
    Database? dbMeliponario;
    int rowsAfetadas = 0;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.delete(caixaTable, where: "$idMeliponarioColunm = ?", whereArgs: [id]).then((value) async {
        await dbMeliponario!.delete(meliponarioTable, where: "$idColumn = ?", whereArgs: [id]).then((value) async {
          rowsAfetadas = value;
        });
      });
    });

    return rowsAfetadas;
  }

  ///deleta uma caixa, suas coletas e suas alimentações usando seu id
  Future<int> deleteCaixa(int id) async {
    Database? dbMeliponario;
    int rowsAfetadas = 0;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.delete(coletaTable, where: "$idCaixaColumn = ?", whereArgs: [id]).then((value) async {
        await dbMeliponario!.delete(alimentacaoTable, where: "$idCaixaColumn = ?", whereArgs: [id]).then((value) async {
          await dbMeliponario!.delete(caixaTable, where: "$idColumn = ?", whereArgs: [id]).then((value) async {
            rowsAfetadas = value;
          });
        });
      });
    });

    return rowsAfetadas;
  }

  Future<int> deleteQueNucaMaisDevoUsarSenaoEuMefodo() async {
    //deleta um meliponário pelo id
    Database? dbMeliponario;
    int rowsAfetadas = 0;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.delete(meliponarioTable).then((value) async {
        rowsAfetadas = value;
      });
    });
    return rowsAfetadas;
  }

  Future<int> updateMeliponario(Meliponario meliponario) async {
    //atualiza o meliponário
    Database? dbMeliponario;
    int rowsAfetadas = 0;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.update(meliponarioTable, meliponario.toMap(),
          where: "$idColumn = ?", whereArgs: [meliponario.id]).then((value) async {
        rowsAfetadas = value;
      });
    });
    return rowsAfetadas;
  }

  ///atualiza uma caixa atraves do objeto
  Future<int> upadateCaixa(Caixa caixa) async {
    Database? dbMeliponario;
    int rowsAfetadas = 0;
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .update(caixaTable, caixa.toMap(), where: "$idColumn = ?", whereArgs: [caixa.id]).then((value) async {
        rowsAfetadas = value;
      });
    });
    return rowsAfetadas;
  }

  Future<double> getPorcentagemProducaoMeliponario(int idMeliponario) async {
    List<Meliponario>? listaMeliponarios;
    double somaTotal = 0;
    double somaMeliponario = 0;

    List<Caixa>? listaCaixa;
    List<Caixa>? listaCaixa2;

    await getAllMeliponarios().then((value) async {
      listaMeliponarios = value;
      for (int i = 0; i < listaMeliponarios!.length; i++) {
        await getAllCaixasApiario(listaMeliponarios![i].id!).then((value) async {
          listaCaixa = value;
          await somarProducao(listaCaixa!).then((value) async {
            somaTotal += value;
          });
        });
      }
    });

    await getAllCaixasApiario(idMeliponario).then((value) async {
      listaCaixa2 = value;
      await somarProducao(listaCaixa2!).then((value) async {
        somaMeliponario = value;
      });
    });

    return (100 * somaMeliponario) / somaTotal;
  }

  Future<double> getPorcentagemProducaoCaixa(Caixa caixa, int idMeliponario) async {
    double somaCaixa = 0;
    double somaMeliponario = 0;
    double operacao = 0;

    List<Caixa> listaCaixa = <Caixa>[];

    await getAllCaixasApiario(idMeliponario).then((value) async {
      listaCaixa = value;
      await somarProducao(listaCaixa).then((smP) async {
        somaMeliponario = smP;
        await somarProducao([caixa]).then((smP2) async {
          somaCaixa = smP2;
          operacao = (100 * somaCaixa) / somaMeliponario;
        });
      });
    });

    return operacao;
  }

  Future<List<double>> getProducaoAnualMeliponario(int idApiario) async {
    List<double> producaoPorAno = <double>[];
    List<int> anos = <int>[];
    List<Caixa>? listaCaixas;
    List<Coleta> coletas;

    await getAllCaixasApiario(idApiario).then((value) async {
      listaCaixas = value;
      await getAnosColetas().then((value) async {
        anos = value;
        for (int i = 0; i < listaCaixas!.length; i++) {
          for (int j = 0; j < anos.length; j++) {
            await getColetasPorAnos(listaCaixas![i].id!, anos[j]).then((value) async {
              coletas = value;
              producaoPorAno.add(somarColetas(coletas));
            });
          }
        }
      });
    });

    return producaoPorAno;
  }

  Future<List<double>> getProducaoAnualCaixa(int idCaixa) async {
    List<double> producaoPorAno = <double>[];
    List<int> anos = <int>[];
    List<Coleta> coletas;

    await getAnosColetas().then((value) async {
      anos = value;
      for (int j = 0; j < anos.length; j++) {
        await getColetasPorAnos(idCaixa, anos[j]).then((value) async {
          coletas = value;
          producaoPorAno.add(somarColetas(coletas));
        });
      }
    });

    return producaoPorAno;
  }

  Future<List<Coleta>> getColetasPorAnos(int idCaixa, int ano) async {
    Database? dbMeliponario;
    List listaColetasMap;
    List<Coleta> listaColetas = <Coleta>[];
    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .rawQuery("SELECT * FROM $coletaTable WHERE $idCaixaColumn = $idCaixa AND $anoColumn = $ano")
          .then((value) async {
        listaColetasMap = value;
        for (Map m in listaColetasMap) {
          listaColetas.add(Coleta.fromMap(m));
        }
      });
    });

    return listaColetas;
  }

  Future<List<int>> getAnosColetas() async {
    Database? dbMeliponario;
    List listaAnosMap;
    List<int> listaAnos = <int>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT DISTINCT $anoColumn FROM $coletaTable").then((value) async {
        listaAnosMap = value;
        for (Map m in listaAnosMap) {
          listaAnos.add(m[anoColumn]);
          listaAnos.sort((a, b) {
            return a.compareTo(b);
          });
        }
      });
    });

    return listaAnos;
  }

  Future<double> somarProducao(List<Caixa> listaCaixas) async {
    double producaoTotal = 0;
    List<Coleta> listaColetas = <Coleta>[];
    int? id = 0;
    Caixa caixa;

    for (int i = 0; i < listaCaixas.length; i++) {
      caixa = listaCaixas[i];
      id = caixa.id;
      await getAllColetasPorCaixa(id!).then((value) async {
        listaColetas = value;
        producaoTotal += somarColetas(listaColetas);
      });
    }

    return producaoTotal;
  }

  double somarColetas(List listaColetas) {
    double producaoTotal = 0;

    for (int i = 0; i < listaColetas.length; i++) {
      producaoTotal += listaColetas[i].quantidade;
    }
    return producaoTotal;
  }

  Future<List<Meliponario>> getAllMeliponarios() async {
    //retorna uma lista de Meliiponarios
    Database? dbMeliponario;
    List listaMeliponariosMap;
    List<Meliponario> listaMeliponarios = <Meliponario>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT * FROM $meliponarioTable").then((value) async {
        listaMeliponariosMap = value;
        for (Map m in listaMeliponariosMap) {
          listaMeliponarios.add(Meliponario.fromMap(m));
        }
      });
    });

    return listaMeliponarios;
  }

  Future<List> getAllColetas() async {
    //retorna uma lista de Meliiponarios
    Database? dbMeliponario;
    List listaColetasMap;
    List<Coleta> listaColetas = <Coleta>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT * FROM $coletaTable").then((value) async {
        listaColetasMap = value;
        for (Map m in listaColetasMap) {
          listaColetas.add(Coleta.fromMap(m));
        }
      });
    });

    return listaColetas;
  }

  ///retorna uma lista de apiários ou meliponários
  Future<List<Meliponario>> getMeliponariosPorCultivo(int cultivo) async {
    Database? dbMeliponario;
    List listaMeliponariosMap;
    List<Meliponario> listaMeliponarios = <Meliponario>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .rawQuery("SELECT * FROM $meliponarioTable WHERE $cultivoColumn = $cultivo")
          .then((value) async {
        listaMeliponariosMap = value;
        for (Map m in listaMeliponariosMap) {
          listaMeliponarios.add(Meliponario.fromMap(m));
        }
        debugPrint("resultados: ");
        debugPrint(listaMeliponarios.length.toString());
      });
    });

    return listaMeliponarios;
  }

  ///retorna uma lista com todas as caixas
  Future<List> getAllCaixas() async {
    Database? dbMeliponario;
    List listaCaixasMap;
    List<Caixa> listaCaixas = <Caixa>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT * FROM $caixaTable").then((value) async {
        listaCaixasMap = value;
        for (Map m in listaCaixasMap) {
          listaCaixas.add(Caixa.fromMap(m));
        }
      });
    });

    return listaCaixas;
  }

  Future<List> getAllAlimentacoes() async {
    Database? dbMeliponario;
    List listaAlimentacoesMap;
    List<Alimentacao> listaAlimentacoes = <Alimentacao>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT * FROM $alimentacaoTable").then((value) async {
        listaAlimentacoesMap = value;
        for (Map m in listaAlimentacoesMap) {
          listaAlimentacoes.add(Alimentacao.fromMap(m));
        }
      });
    });

    return listaAlimentacoes;
  }

  Future<int?> getNumberMeliponario() async {
    //ao fim da implementação dessa classe tornar essa função utilizavel para toda as tabelas || passar o parametro table
    Database? dbMeliponario;
    int? rowsAfected = 0;
    await db.then((value) async {
      dbMeliponario = value;
      rowsAfected = Sqflite.firstIntValue(await dbMeliponario!
          .rawQuery("SELECT COUNT(*) FROM $meliponarioTable")); //usar tabel ao invés de meliponário table
    });
    return rowsAfected;
  }

  ///retorna uma lista com todas as caixas de um apiario
  Future<List<Caixa>> getAllCaixasApiario(int idApiario) async {
    Database? dbMeliponario;
    List listaCaixasMap;
    List<Caixa> listaCaixas = <Caixa>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .rawQuery("SELECT * FROM $caixaTable WHERE $idMeliponarioColunm = $idApiario")
          .then((value) async {
        listaCaixasMap = value;
        for (Map m in listaCaixasMap) {
          listaCaixas.add(Caixa.fromMap(m));
        }
        debugPrint("qtd de dados: ");
        debugPrint(listaCaixas.length.toString());
      });
    });

    return listaCaixas;
  }

  Future<List<Coleta>> getAllColetasPorCaixa(int idCaixa) async {
    Database? dbMeliponario;
    List<Map<dynamic, dynamic>> listaColetasMap = <Map<dynamic, dynamic>>[];
    List<Coleta> listaColetas = <Coleta>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!.rawQuery("SELECT * FROM $coletaTable WHERE $idCaixaColumn = $idCaixa").then((value) {
        listaColetasMap = value;
        for (Map m in listaColetasMap) {
          listaColetas.add(Coleta.fromMap(m));
        }
      });
    });
    debugPrint("qtd de dados: ");
    debugPrint(listaColetas.length.toString());

    return listaColetas;
  }

  Future<List<Alimentacao>> getAllAlimwntacaoesPorCaixa(int idCaixa) async {
    Database? dbMeliponario;
    List listaAlimentacoesMap;
    List<Alimentacao> listaAlimentacaos = <Alimentacao>[];

    await db.then((value) async {
      dbMeliponario = value;
      await dbMeliponario!
          .rawQuery("SELECT * FROM $alimentacaoTable WHERE $idCaixaColumn = $idCaixa")
          .then((value) async {
        listaAlimentacoesMap = value;
        for (Map m in listaAlimentacoesMap) {
          listaAlimentacaos.add(Alimentacao.fromMap(m));
        }
        debugPrint("qtd de dados: ");
        debugPrint(listaAlimentacaos.length.toString());
      });
    });

    return listaAlimentacaos;
  }

  Future close() async {
    Database? dbMeliponario;
    await db.then((value) async {
      await dbMeliponario!.close();
    });
  }
}

class Meliponario {
  int? id;
  String? nome;
  String? descricao;
  String? data;
  String? image;
  int? cultivo; //1 para meliponario 0 para apiario

  Meliponario();

  Meliponario.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    descricao = map[descricaoColumn];
    data = map[dataColumn]; //primeiro erro, nome da variável errado.
    image = map[imageColumn];
    cultivo = map[cultivoColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      descricaoColumn: descricao,
      dataColumn: data,
      imageColumn: image,
      cultivoColumn: cultivo
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Meliponario{id: $id, nome: $nome, descricao: $descricao, data: $data, image: $image, cultivo: $cultivo}';
  }
}

class Caixa {
  int? id;
  String? nome;
  int? idMeliponario;
  int? valorMaximoTemperatura;
  int? valorMinimoTemperatura;
  String? data;
  String? image;

  Caixa();

  Caixa.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    idMeliponario = map[idMeliponarioColunm];
    data = map[dataColumn];
    image = map[imageColumn];
    valorMaximoTemperatura = map[valorMaximoTemperaturaColunm];
    valorMinimoTemperatura = map[valorMinimoTemperaturaColunm];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      dataColumn: data,
      imageColumn: image,
      idMeliponarioColunm: idMeliponario,
      valorMinimoTemperaturaColunm: valorMinimoTemperatura,
      valorMaximoTemperaturaColunm: valorMaximoTemperatura,
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Caixa(id: $id, nome: $nome, data: $data, idMeliponário: $idMeliponario)";
  }
}

class Coleta {
  int? id;
  double? quantidade;
  String? data;
  int? idCaixa;
  int? ano;

  Coleta();

  Coleta.fromMap(Map map) {
    id = map[idColumn];
    quantidade = map[quantidadeColumn];
    data = map[dataColumn];
    idCaixa = map[idCaixaColumn];
    ano = map[anoColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {dataColumn: data, quantidadeColumn: quantidade, idCaixaColumn: idCaixa, anoColumn: ano};

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Coleta{id: $id, quantidade: $quantidade, data: $data, idCaixa: $idCaixa, ano: $ano}';
  }
}

class Alimentacao {
  int? id;
  double? quantidade;
  String? data;
  int? tipo; //0 para energética, 1 para protéica, 2 para mista
  int? idCaixa;

  Alimentacao();

  Alimentacao.fromMap(Map map) {
    id = map[idColumn];
    quantidade = map[quantidadeColumn];
    data = map[dataColumn];
    tipo = map[tipoAlimentacaoColumn];
    idCaixa = map[idCaixaColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      dataColumn: data,
      quantidadeColumn: quantidade,
      tipoAlimentacaoColumn: tipo,
      idCaixaColumn: idCaixa
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Alimentacao{id: $id, quantidade: $quantidade, data: $data, tipo: $tipo, idCaixa: $idCaixa}';
  }
}
