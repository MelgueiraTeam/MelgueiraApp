import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String meliponarioTable = "meliponarioTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String descricaoColumn = "descricaoColumn";
final String dataColumn = "dataColumn";
final String imageColumn = "imageColumn";

final String caixaTable = "caixaTable";
final String idMeliponarioColunm = "idMeliponarioColunm";
final String valorMaximoTemperaturaColunm = "valorMaximoTemperaturaColunm";
final String valorMinimoTemperaturaColunm = "valorMinimoTemperaturaColunm";

class MeliponarioHelper {
  static final MeliponarioHelper _instance = MeliponarioHelper.internal();

  factory MeliponarioHelper() => _instance;

  MeliponarioHelper.internal();

  Database _db;

  Future<Database>get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database>initDb() async{
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "meliponariosnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
        "CREATE TABLE $meliponarioTable($idColumn INTEGER PRIMARY KEY,"
            "$nomeColumn TEXT,"
            "$descricaoColumn TEXT,"
            "$dataColumn DATE, "
            "$imageColumn TEXT);"

        /*
            "CREATE TABLE $caixaTable($idColumn INTEGER PRIMARY KEY,"
            "$nomeColumn TEXT,"
            "$descricaoColumn TEXT,"
            "$dataColumn DATA, "
            "$imageColumn TEXT,"
            "$idMeliponarioColunm INTEGER FOREGEIN KEY,"
            "$valorMaximoTemperaturaColunm INTEGER,"
            "$valorMinimoTemperaturaColunm INTEGER);"*/
      );

      await db.execute(
          "CREATE TABLE $caixaTable($idColumn INTEGER PRIMARY KEY,"
              "$nomeColumn TEXT,"
              "$descricaoColumn TEXT,"
              "$dataColumn DATA, "
              "$imageColumn TEXT,"
              "$idMeliponarioColunm INTEGER FOREGEIN KEY,"
              "$valorMaximoTemperaturaColunm INTEGER,"
              "$valorMinimoTemperaturaColunm INTEGER);"
      );
    });

  }

  Future<Meliponario>saveMeliponario(Meliponario meliponario) async{//faz o insert de um meliponário no db
    Database dbMeliponario = await db;
    meliponario.id = await dbMeliponario.insert(meliponarioTable, meliponario.toMap());
    return meliponario;
  }

  ///faz um insert da caixa no db
  Future<Caixa>saveCaixa(Caixa caixa) async{
    Database dbMeliponario = await db;
    caixa.id = await dbMeliponario.insert(caixaTable, caixa.toMap());
    return caixa;
  }

  Future<Meliponario>getMeliponario(int id) async{//faz uma query por meio do id
    Database dbMeliponario = await db;
    List<Map> maps = await dbMeliponario.query(meliponarioTable,
      columns: [idColumn, nomeColumn, dataColumn, imageColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if(maps.length > 0){
      return Meliponario.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteMeliponario(int id) async{//deleta um meliponário pelo id
    Database dbMeliponario = await db;
    return await dbMeliponario.delete(meliponarioTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  ///deleta uma caixa usando seu id no bd
  Future<int> deleteCaixa(int id) async{
    Database dbMeliponario = await db;
    return await dbMeliponario.delete(caixaTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> deleteQueNucaMaisDevoUsarSenaoEuMefodo() async{//deleta um meliponário pelo id
    Database dbMeliponario = await db;
    return await dbMeliponario.delete(meliponarioTable);
  }

  Future<int> updateMeliponario(Meliponario meliponario)async{//atualiza o meliponário
    Database dbMeliponario = await db;
    return await dbMeliponario.update(meliponarioTable,
        meliponario.toMap(),
        where: "$idColumn = ?",
        whereArgs: [meliponario.id]);
  }

  Future<int> updateCaixa(Caixa caixa)async{//atualiza o meliponário
    Database dbMeliponario = await db;
    return await dbMeliponario.update(caixaTable,
        caixa.toMap(),
        where: "$idColumn = ?",
        whereArgs: [caixa.id]);
  }

  ///retorna uma lista com todos os meliponários
  Future<List> getAllMeliponarios() async{
    Database dbMeliponario = await db;
    List listaMeliponariosMap = await dbMeliponario.rawQuery("SELECT * FROM $meliponarioTable");
    List<Meliponario> listaMeliponarios = List();
    for(Map m in listaMeliponariosMap){
      listaMeliponarios.add(Meliponario.fromMap(m));
    }
    return listaMeliponarios;
  }

  ///retorna uma lista com todas as caixas
  Future<List> getAllCaixas() async{
    Database dbMeliponario = await db;
    List listaCaixasMap = await dbMeliponario.rawQuery("SELECT * FROM $caixaTable");
    List<Caixa> listaCaixas = List();
    for(Map m in listaCaixasMap){
      listaCaixas.add(Caixa.fromMap(m));
    }
    print("qtd de dados: ");
    print(listaCaixas.length);

    return listaCaixas;
  }

  ///retorna uma lista com todas as caixas de um apiario
  Future<List> getAllCaixasApiario(int idApiario) async{
    Database dbMeliponario = await db;
    List listaCaixasMap = await dbMeliponario.rawQuery("SELECT * FROM $caixaTable WHERE $idMeliponarioColunm = $idApiario");
    List<Caixa> listaCaixas = List();
    for(Map m in listaCaixasMap){
      listaCaixas.add(Caixa.fromMap(m));
    }
    print("qtd de dados: ");
    print(listaCaixas.length);

    return listaCaixas;
  }

  Future<int> getNumberMeliponario() async{//ao fim da implementação dessa classe tornar essa função utilizavel para toda as tabelas || passar o parametro table
    Database dbMeliponario = await db;
    return Sqflite.firstIntValue(await dbMeliponario.rawQuery("SELECT COUNT(*) FROM $meliponarioTable"));//usar tabel ao invés de meliponário table
  }

  Future close() async{
    Database dbMeliponario = await db;
    await dbMeliponario.close();
  }
}

class Meliponario {
  int id;
  String nome;
  String descricao;
  String data;
  String image;


  Meliponario();

  Meliponario.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    descricao = map[descricaoColumn];
    data = map[dataColumn];//primeiro erro, nome da variável errado.
    image = map[imageColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nomeColumn: nome,
      descricaoColumn: descricao,
      dataColumn: data,
      imageColumn: image
    };

    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Meliponário(id: $id, nome: $nome, descrição: $descricao, data: $data, imagem: $image)";
  }
}

class Caixa {
  int id;
  String nome;
  int idMeliponario;
  int valorMaximoTemperatura;
  int valorMinimoTemperatura;
  String data;
  String image;


  Caixa();

  Caixa.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    idMeliponario = map[idMeliponarioColunm];
    data = map[dataColumn];
    image = map[imageColumn];
    valorMaximoTemperatura = map[valorMaximoTemperaturaColunm];
    valorMinimoTemperatura = map[valorMinimoTemperaturaColunm];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nomeColumn: nome,
      dataColumn: data,
      imageColumn: image,
      idMeliponarioColunm: idMeliponario,
      valorMinimoTemperaturaColunm: valorMinimoTemperatura,
      valorMaximoTemperaturaColunm: valorMaximoTemperatura,
    };

    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Caixa(id: $id, nome: $nome, data: $data, idMeliponário: $idMeliponario)";
  }
}

