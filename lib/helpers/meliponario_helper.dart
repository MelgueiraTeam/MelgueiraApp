import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String meliponarioTable = "meliponarioTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String descricaoColumn = "descricaoColumn";
final String dataColumn = "dataColumn";
final String imageColumn = "imageColumn";
final String cultivoColumn = "cultivoColumn";

final String caixaTable = "caixaTable";
final String idMeliponarioColunm = "idMeliponarioColunm";
final String valorMaximoTemperaturaColunm = "valorMaximoTemperaturaColunm";
final String valorMinimoTemperaturaColunm = "valorMinimoTemperaturaColunm";

final String coletaTable = "coletaTable";
final String quantidadeColumn = "quantidadeColumn";
final String idCaixaColumn = "idCaixaColumn";

final String alimentacaoTable = "alimentacaoTable";
final String tipoAlimentacaoColumn = "tipoAlimentacaoColumn";

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

      await db.execute(
          "CREATE TABLE $caixaTable($idColumn INTEGER PRIMARY KEY,"
              "$nomeColumn TEXT,"
              "$descricaoColumn TEXT,"
              "$dataColumn TEXT,"
              "$imageColumn TEXT,"
              "$idMeliponarioColunm INTEGER,"
              "$valorMaximoTemperaturaColunm INTEGER,"
              "$valorMinimoTemperaturaColunm INTEGER);"
      );

      await db.execute(
        "CREATE TABLE $coletaTable($idColumn INTEGER PRIMARY KEY,"
            "$dataColumn TEXT,"
            "$quantidadeColumn REAL,"
            "$idCaixaColumn INTEGER);"
      );

      await db.execute(
        "CREATE TABLE $alimentacaoTable($idColumn INTEGER PRIMARY KEY,"
            "$dataColumn TEXT,"
            "$quantidadeColumn REAL"
            "$tipoAlimentacaoColumn INTEGER,"
            "$idCaixaColumn INTEGER);"
      );
    }
    );

  }

  Future<Meliponario>saveMeliponario(Meliponario meliponario) async{//faz o insert de um meliponário no db
    Database dbMeliponario = await db;
    meliponario.id = await dbMeliponario.insert(meliponarioTable, meliponario.toMap());
    return meliponario;
  }

  Future<Caixa>saveCaixa(Caixa caixa) async{//faz o insert de uma caixa no db
    Database dbMeliponario = await db;
    caixa.id = await dbMeliponario.insert(caixaTable, caixa.toMap());
    return caixa;
  }

  ///salva uma coleta e define seu id
  Future<Coleta>saveColeta(Coleta coleta) async{
    Database dbMeliponario = await db;
    coleta.id = await dbMeliponario.insert(coletaTable, coleta.toMap());
    return coleta;
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

  ///deleta um apiário e todas as suas caixas pelo id
  Future<int> deleteMeliponario(int id) async{
    Database dbMeliponario = await db;
    await dbMeliponario.delete(caixaTable, where: "$idMeliponarioColunm = ?", whereArgs: [id]);
    return await dbMeliponario.delete(meliponarioTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  ///deleta uma caixa usando seu id
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

  ///atualiza uma caixa atraves do objeto
  Future<int> upadateCaixa(Caixa caixa)async{
    Database dbMeliponario = await db;
    return await dbMeliponario.update(caixaTable,
        caixa.toMap(),
        where: "$idColumn = ?",
        whereArgs: [caixa.id]);
  }

  Future<List> getAllMeliponarios() async{//retorna uma lista de Meliiponarios
    Database dbMeliponario = await db;
    List listaMeliponariosMap = await dbMeliponario.rawQuery("SELECT * FROM $meliponarioTable");
    List<Meliponario> listaMeliponarios = List();
    for(Map m in listaMeliponariosMap){
      listaMeliponarios.add(Meliponario.fromMap(m));
    }
    return listaMeliponarios;
  }

  Future<List> getAllColetas() async{//retorna uma lista de Meliiponarios
    Database dbMeliponario = await db;
    List listaColetasMap = await dbMeliponario.rawQuery("SELECT * FROM $coletaTable");
    List<Coleta> listaColetas = List();
    for(Map m in listaColetasMap){
      listaColetas.add(Coleta.fromMap(m));
    }
    return listaColetas;
  }

  ///retorna uma lista de apiários ou meliponários
  Future<List> getMeliponariosPorCultivo(int cultivo) async{
    Database dbMeliponario = await db;
    List listaMeliponariosMap = await dbMeliponario.rawQuery("SELECT * FROM $meliponarioTable WHERE $cultivoColumn = $cultivo");
    List<Meliponario> listaMeliponarios = List();
    for(Map m in listaMeliponariosMap){
      listaMeliponarios.add(Meliponario.fromMap(m));
    }
    print("resultados: ");
    print(listaMeliponarios.length);
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
    return listaCaixas;
  }

  Future<int> getNumberMeliponario() async{//ao fim da implementação dessa classe tornar essa função utilizavel para toda as tabelas || passar o parametro table
    Database dbMeliponario = await db;
    return Sqflite.firstIntValue(await dbMeliponario.rawQuery("SELECT COUNT(*) FROM $meliponarioTable"));//usar tabel ao invés de meliponário table
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

  Future<List> getAllColetasPorCaixa(int idCaixa) async{
    Database dbMeliponario = await db;
    List listaColetasMap = await dbMeliponario.rawQuery("SELECT * FROM $coletaTable WHERE $idCaixaColumn = $idCaixa");
    List<Coleta> listaColetas = List();
    for(Map m in listaColetasMap){
      listaColetas.add(Coleta.fromMap(m));
    }
    print("qtd de dados: ");
    print(listaColetas.length);

    return listaColetas;
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
  int cultivo;//1 para meliponario 0 para apiario

  Meliponario();

  Meliponario.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    descricao = map[descricaoColumn];
    data = map[dataColumn];//primeiro erro, nome da variável errado.
    image = map[imageColumn];
    cultivo = map[cultivoColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nomeColumn: nome,
      descricaoColumn: descricao,
      dataColumn: data,
      imageColumn: image,
      cultivoColumn: cultivo
    };

    if(id != null){
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

class Coleta {
  int id;
  double quantidade;
  String data;
  int idCaixa;


  Coleta();

  Coleta.fromMap(Map map){
    id = map[idColumn];
    quantidade = map[quantidadeColumn];
    data = map[dataColumn];
    idCaixa = map[idCaixaColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      dataColumn: data,
      quantidadeColumn: quantidade,
      idCaixaColumn: idCaixa
    };

    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Coleta{id: $id, quantidade: $quantidade, data: $data, idCaixa: $idCaixa}';
  }
}

class Alimentacao {
  int id;
  double quantidade;
  String data;
  int tipo;//0 para energética, 1 para protéica, 2 para mista
  int idCaixa;



  Alimentacao();

  Alimentacao.fromMap(Map map){
    id = map[idColumn];
    quantidade = map[quantidadeColumn];
    data = map[dataColumn];
    tipo = map[tipoAlimentacaoColumn];
    idCaixa = map[idCaixaColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      dataColumn: data,
      quantidadeColumn: quantidade,
      tipoAlimentacaoColumn: tipo,
      idCaixaColumn: idCaixa
    };

    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Coleta{id: $id, quantidade: $quantidade, data: $data, idCaixa: $idCaixa}';
  }
}

