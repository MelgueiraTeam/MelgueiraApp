import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/cadastro_meliponario.dart';
import 'package:melgueira_app/ui/meliponarios_page/listaApiarios.dart';
import 'package:melgueira_app/ui/meliponarios_page/lista_meliponarios.dart';
import '../leitor_qr_code.dart';

enum OrderOptions { orderaz, orderdc }

class TelaMeliponarios extends StatefulWidget {
  const TelaMeliponarios({Key? key}) : super(key: key);

  @override
  TelaMeliponariosState createState() => TelaMeliponariosState();
}

class TelaMeliponariosState extends State<TelaMeliponarios> with SingleTickerProviderStateMixin {
  MeliponarioHelper helper = MeliponarioHelper();
  int _tabAtual = 0;

  List<Meliponario> lMeliponarios = <Meliponario>[];
  List<Meliponario> lApiarios = <Meliponario>[];

  List<Tab> myTabs = const <Tab>[
    Tab(
      text: "Apiários",
    ),
    Tab(
      text: "Meliponários",
    )
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("MelgueirApp"),
            backgroundColor: const Color.fromARGB(255, 255, 166, 78),
            centerTitle: true,
            actions: [
              PopupMenuButton<OrderOptions>(
                //copiei descaradamente pq n sabia direito o que tava fazendo kk
                itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar alfabeticamente"),
                    value: OrderOptions.orderaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar por data de criação"),
                    value: OrderOptions.orderdc,
                  ),
                ],
                onSelected: _ordenarLista,
              ),
              TextButton(
                  onPressed: () {
                    _showLeitorQrPage();
                  },
                  child: const Icon(Icons.qr_code))
            ],
            bottom: TabBar(
              tabs: myTabs,
              /*  controller: tabController,*/
            ),
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Meliponario? mp;
              _showCadastroPage(meliponario: mp);
            },
            child: const Icon(Icons.add),
          ),
          body: TabBarView(
            children: [
              ListaApiarios(atualizaTabAtual, _showCadastroPage, lApiarios),
              ListaMeliponarios(atualizaTabAtual, _showCadastroPage, lMeliponarios),
            ],
          ),
        ));
  }

  atualizaTabAtual(int i) {
    _tabAtual = i;
  }

  Future _showCadastroPage({Meliponario? meliponario}) async {
    dynamic recMeliponario;

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroMeliponarioPage(
                  meliponario: meliponario,
                  helper: helper,
                  cultivo: _tabAtual,
                ))).then((value) async {
      recMeliponario = value;
      if (recMeliponario != null) {
        if (meliponario != null) {
          await helper.updateMeliponario(recMeliponario).then((value) async {
            await _getAllApiarios().then((value) async {
              await _getAllMeliponarios();
            });
          });
        } else {
          await helper.saveMeliponario(recMeliponario).then((value) async {
            await _getAllApiarios().then((value) async {
              await _getAllMeliponarios();
            });
          });
        }
      } else {
        await _getAllApiarios().then((value) async {
          await _getAllMeliponarios();
        });
      }
    });
  }

  Future _ordenarLista(OrderOptions resultado) async {
    switch (resultado) {
      case OrderOptions.orderaz:
        await _getAllApiarios().then((value) async {
          setState(() {
            lApiarios.sort((a, b) {
              return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
            });
          });

          await _getAllMeliponarios().then((value) async {
            setState(() {
              lMeliponarios.sort((a, b) {
                return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
              });
            });
          });
        });

        break;
      case OrderOptions.orderdc:
        await _getAllApiarios().then((value) async {
          setState(() {
            lApiarios.sort((a, b) {
              return a.data!.toLowerCase().compareTo(b.data!.toLowerCase()); //formatar de String para DataTime
            });
          });
          await _getAllMeliponarios().then((value) async {
            setState(() {
              lMeliponarios.sort((a, b) {
                return a.data!.toLowerCase().compareTo(b.data!.toLowerCase()); //formatar de String para DataTime
              });
            });
          });
        });
        break;
    }
    setState(() {});
  }

  Future _getAllMeliponarios() async {
    await helper.getMeliponariosPorCultivo().then((list) async {
      setState(() {
        lMeliponarios = list;
      });
    });
  }

  Future _getAllApiarios() async {
    await helper.getApiariosPorCultivo().then((list) async {
      setState(() {
        lApiarios = list;
      });
    });
  }

  void _showLeitorQrPage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const LeitorPage()));
  }
}
