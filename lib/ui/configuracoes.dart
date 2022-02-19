import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entidades/banco_dados/data_base.dart';
import '../entidades/config_json.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  static TextEditingController tecIp = TextEditingController();
  static TextEditingController tecPorta = TextEditingController();
  static TextEditingController tecUsuario = TextEditingController();
  static TextEditingController tecSenha = TextEditingController();
  static TextEditingController tecBanco = TextEditingController();
  static TextEditingController tecIdCaixa = TextEditingController();

  bool ignoraEventosTela = false;

  Future<String>? carregaDados;

  Widget? statusCarregamento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                  future: carregaDados,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget children;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      children = const SizedBox(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      children = const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 30,
                      );
                    } else {
                      children = const Icon(
                        Icons.check_circle_outline,
                        color: Colors.greenAccent,
                        size: 30,
                      );
                    }

                    return children;
                  }),
            ),
          ],
        ),
        body: AbsorbPointer(
          absorbing: ignoraEventosTela,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Banco de Dados",
                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
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
                                    decoration: const InputDecoration(
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
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    controller: tecPorta,
                                    onChanged: (value) {},
                                    decoration: const InputDecoration(
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
                                    decoration: const InputDecoration(
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
                                    decoration: const InputDecoration(
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
                                    decoration: const InputDecoration(
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
                                  padding: const EdgeInsets.fromLTRB(10, 8.0, 10, 8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          DataBase.ip = tecIp.text;
                                          DataBase.porta = tecPorta.text;
                                          DataBase.usuario = tecUsuario.text;
                                          DataBase.senha = tecSenha.text;
                                          DataBase.nomeBanco = tecBanco.text;

                                          ConfigJson.saveData(ConfigJson.toJson());

                                          setState(() {
                                            ignoraEventosTela = true;
                                            carregaDados = Future<String>.delayed(Duration.zero, () async {
                                              try {
                                                await DataBase.getConexao().then((value) {
                                                  showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text('Conexão com Banco de Dados'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(value
                                                                    ? "Sucesso ao conectar no banco de dados!"
                                                                    : "Erro ao conectar no banco de dados: " +
                                                                        DataBase.erroConexao),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  setState(() {
                                                    ignoraEventosTela = false;
                                                  });
                                                });
                                              } catch (e) {
                                                setState(() {
                                                  ignoraEventosTela = false;
                                                });
                                                showDialog<void>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Conexão com Banco de Dados'),
                                                        content: SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text("Erro ao tentar gerar conexão com banco de dados: " +
                                                                  e.toString()),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                              return 'Data Loaded';
                                            });
                                          });
                                        },
                                        child: const Text("Conectar/Gravar")),
                                  ),
                                ),
                              ],
                            ),
                            shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 10,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ));
  }

  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      carregaDados = Future<String>.delayed(Duration.zero, () async {
        await ConfigJson.readConfigJson(gerarConexaoBanco: false).then((value) {
          setState(() {
            tecIp.text = DataBase.ip;
            tecPorta.text = DataBase.porta;
            tecUsuario.text = DataBase.usuario;
            tecSenha.text = DataBase.senha;
            tecBanco.text = DataBase.nomeBanco;
            tecIdCaixa.text = ConfigJson.idCaixa;

            tecIp.text = "melgueira.com";
            tecPorta.text = "3306";
            tecUsuario.text = "melgue20_usuario_usabilidade";
            tecSenha.text = "melgue20_usuario_usabilidade";
            tecBanco.text = "melgue20_Melgueira_Box";
          });
        });

        return 'Data Loaded';
      });
    });
    super.initState();
  }
}
