import 'dart:io';
import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/cadastro_meliponario.dart';
import 'package:melgueira_app/ui/caixas.dart';
import 'package:melgueira_app/ui/dashboard_meliponario_page.dart';

import 'leitor_qr_code.dart';

enum OrderOptions { orderaz, orderdc }

class TelaMeliponarios extends StatefulWidget {
  const TelaMeliponarios({Key? key}) : super(key: key);

  @override
  TelaMeliponariosState createState() => TelaMeliponariosState();
}

class TelaMeliponariosState extends State<TelaMeliponarios> with TickerProviderStateMixin {
  MeliponarioHelper helper = MeliponarioHelper();
  List<Meliponario> cultivos = <Meliponario>[];
  int _tabAtual = 0;

  @override
  initState() {
    super.initState();

    _getAllMeliponarios();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            final tabController = DefaultTabController.of(context);
            tabController!.addListener(() {
              if (!tabController.indexIsChanging) {
                _tabAtual = tabController.index;
                _getAllMeliponarios();
                debugPrint("tabAtual: ");
                debugPrint(_tabAtual.toString());
              }
            });
            return Scaffold(
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
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "Apiários",
                    ),
                    Tab(
                      text: "Meliponários",
                    )
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Meliponario? mp;
                  _showCadastroPage(meliponario: mp);
                },
                child: const Icon(Icons.add),
                //backgroundColor: Color.fromARGB(255, 255, 166, 78),
              ),
              body: cultivos.isEmpty
                  ? const Center(
                      child: Text("Nenhum Registro"),
                    )
                  : TabBarView(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: cultivos.length,
                          itemBuilder: (context, index) {
                            return _createCard(context, index);
                          },
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: cultivos.length,
                          itemBuilder: (context, index) {

                            return _createCard(context, index);
                          },
                        )
                      ],
                    ),
            );
          },
        ));
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showCaixasPage(
          cultivos[index].id!,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(

                    //shape: BoxShape.circle,

                    image: DecorationImage(
                        image: cultivos[index].image != null
                            ? FileImage(File(cultivos[index].image!))
                            : const AssetImage("images/person.png") as ImageProvider)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarTexto(cultivos[index].nome!),
                      overflow: TextOverflow.fade,
                      //verificação inutil, já que, é impossivel salvar sem o nome
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: " + cultivos[index].data!,
                      //cultivos[index].data ?? "sem data",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      //"Descrição: " + meliponarios[index].descricao ?? "",
                      _formatarTexto(cultivos[index].descricao!),
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //pedir para o professor pq n tá funcionando

                children: [
                  IconButton(
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      _showDashboardMeliponarioPage(cultivos[index]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showCadastroPage(meliponario: cultivos[index]);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCaixasPage(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CaixasPage(
                  idApiario: id,
                )));
  }

  void _showCadastroPage({Meliponario? meliponario}) async {
    final recMeliponario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroMeliponarioPage(
                  meliponario: meliponario,
                  helper: helper,
                  cultivo: _tabAtual,
                )));

    if (recMeliponario != null) {
      if (meliponario != null) {
        await helper.updateMeliponario(recMeliponario);
      } else {
        await helper.saveMeliponario(recMeliponario);
      }
    }
    debugPrint("cultivo: ");
    debugPrint(recMeliponario.toString());

    _getAllMeliponarios();
  }

  void _showDashboardMeliponarioPage(Meliponario meliponario) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMelponariosPage(meliponario: meliponario)));
  }

  Future _getAllMeliponarios() async {
    await helper.getMeliponariosPorCultivo(_tabAtual).then((list) async {
      setState(() {
        cultivos = list;
      });
      debugPrint("Saiu da Função");
    });
  }

  // void _separarPorCultivo  (){
  //   List<Meliponario> aux = <Meliponario>[];
  //  for(Meliponario m in cultivos){
  //    if(m.cultivo == _tabAtual){
//      aux.add(m);
//     }
  //   }
//  cultivos = aux;
  // }

  void _ordenarLista(OrderOptions resultado) {
    switch (resultado) {
      case OrderOptions.orderaz:
        cultivos.sort((a, b) {
          return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
        });
        break;
      case OrderOptions.orderdc:
        cultivos.sort((a, b) {
          return a.data!.toLowerCase().compareTo(b.data!.toLowerCase()); //formatar de String para DataTime
        });
        break;
    }
    setState(() {});
  }

  String _formatarTexto(String texto) {
    if (texto.length > 15) {
      texto = texto.substring(0, 14);
      texto += "...";
    }

    return texto;
  }

  void _showLeitorQrPage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const LeitorPage()));
  }
}
