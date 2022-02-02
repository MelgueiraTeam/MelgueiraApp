import 'package:flutter/material.dart';
import 'package:melgueira_app/entidades/banco_dados/data_base.dart';
import 'package:melgueira_app/entidades/banco_dados/alerta.dart';
import 'package:melgueira_app/entidades/config_json.dart';
import 'package:melgueira_app/entidades/notificacoes/service.dart';
import 'package:melgueira_app/telas/alerts/alert_form.dart';
import 'package:melgueira_app/telas/alerts/alert_list.dart';
import 'package:timezone/data/latest.dart' as tz;

class Alertas extends StatefulWidget {
  const Alertas({Key? key}) : super(key: key);

  @override
  AlertasState createState() => AlertasState();
}

class AlertasState extends State<Alertas> {
  static List<Alerta> listaAlertas = <Alerta>[];
  static Future<String>? carregaDados;

  int codigoMaisAlto = 0;
  bool ignoraEventosTela = false;
  bool exibeBotaoTela = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
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
                  } else if(snapshot.data == "") {
                    children = const SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
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
      body:  AbsorbPointer(
        absorbing: ignoraEventosTela,
        child: SingleChildScrollView(
            child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: listaAlertas.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: const [
                                Text(
                                  "Não há Alertas Cadastrados!",
                                  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.clear_outlined),
                                )
                              ],
                            ),
                          )
                        ]
                      : [AlertList(listaAlertas, deletaAlerta, fnAbreFormularioEdicao)]),
              ElevatedButton(
                  onPressed: () async {
                    await carregaAlertas();
                  },
                  child: const Text(
                    "Atualizar Lista",
                  )),
            ],
          ),
        )),
      ),
      floatingActionButton: Visibility(
        visible: exibeBotaoTela,
        child: FloatingActionButton(

          onPressed: () {
            if(ignoraEventosTela!= true) {
              openAlertFormModal();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  openAlertFormModal() {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 1,
              builder: (_, controller) => Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        AlertsForm(carregaAlertas, codigoMaisAlto, null, desativaInteracaoTela, ativaInteracaoTela, geraNotificacao, fnGerarNotificacao),
                      ],
                    ),
                  ));
        });
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        tz.initializeTimeZones();
        carregaDados = Future<String>.delayed(Duration.zero, () async {
          await ConfigJson.readConfigJson(gerarConexaoBanco: true).then((estadoConexao) async {
            await DataBase.getAlertas(ConfigJson.idCaixa).then((retornoGetAlerta) async {
              listaAlertas = retornoGetAlerta;

              await DataBase.getMaxIdAlerts().then((value) {
                codigoMaisAlto = value;
              });
            });
          });
          atualizaLista();
          return 'Data Loaded';
        });
      });
    });
  }

  @override
  dispose() {
    listaAlertas = <Alerta>[];
    super.dispose();
  }

  fnAbreFormularioEdicao(Alerta? alerta) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 1,
              builder: (_, controller) => Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        AlertsForm(carregaAlertas, codigoMaisAlto, alerta, desativaInteracaoTela, ativaInteracaoTela, geraNotificacao, fnGerarNotificacao),
                      ],
                    ),
                  ));
        });
  }

  Future geraNotificacao(Alerta? alertaObj) async {
    if (alertaObj != null) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edição de Alertas'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("Sucesso ao editar Alerta no banco de dados!"),
                  ],
                ),
              ),
            );
          });
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cadastro de Alertas'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("Sucesso ao salvar Alerta no banco de dados!"),
                  ],
                ),
              ),
            );
          });
    }
  }

  Future desativaInteracaoTela() async {
    setState(() {
      exibeBotaoTela = false;
      ignoraEventosTela = true;
      carregaDados = Future<String>.value('');
    });
  }

  Future ativaInteracaoTela() async {
    setState(() {
      exibeBotaoTela = true;
      ignoraEventosTela = false;
      carregaDados = Future<String>.delayed(Duration.zero, () async {
        return 'Data Loaded';
      });
    });
  }



  Future deletaAlerta(String id) async {
    setState(() {
      exibeBotaoTela = false;
      ignoraEventosTela = true;
      AlertasState.carregaDados = Future<String>.delayed(Duration.zero, () async {
        await DataBase.deleteAlerta(id).then((value) async {
          await carregaAlertas().then((value){
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exclusão de Alertas'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text("Sucesso ao deletar Alerta do banco de dados!"),
                        ],
                      ),
                    ),
                  );
                });
            exibeBotaoTela = true;
            ignoraEventosTela = false;
          });
        });

        return 'Data Loaded';
      });
    });
  }

  Future fnGerarNotificacao() async {

  }

  Future carregaAlertas() async {
    await DataBase.getAlertas(ConfigJson.idCaixa).then((alertas) async {
      AlertasState.listaAlertas = alertas;
      await DataBase.getMaxIdAlerts().then((value) {
        codigoMaisAlto = value;
      });
    });
    setState(() {
      AlertasState.listaAlertas;
      codigoMaisAlto;
    });
  }

  Future atualizaLista() async {
    setState(() {
      carregaDados;
      listaAlertas;
      codigoMaisAlto;
    });
  }
}
