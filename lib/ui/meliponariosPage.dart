import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastroMeliponario.dart';
import 'package:prototipo_01/ui/caixas.dart';
import 'package:prototipo_01/ui/dashboard_meliponario_page.dart';

import 'leitor_qr_code.dart';

enum OrderOptions { orderaz, orderdc }

class TelaMeliponarios extends StatefulWidget {
  const TelaMeliponarios({Key key}) : super(key: key);

  @override
  TelaMeliponariosState createState() => TelaMeliponariosState();
}

class TelaMeliponariosState extends State<TelaMeliponarios> {

  MeliponarioHelper helper = MeliponarioHelper();
  List<Meliponario> cultivos = List();
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
          builder: (BuildContext context){
            final tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              if(!tabController.indexIsChanging){
                _tabAtual = tabController.index;
                _getAllMeliponarios();
                print("tabAtual: ");
                print(_tabAtual);
              }
            });
            return Scaffold(
              appBar: AppBar(
                title: Text("MelgueirApp"),
                backgroundColor: Color.fromARGB(255, 255, 166, 78),
                centerTitle: true,
                actions: [
                  PopupMenuButton<OrderOptions>( //copiei descaradamente pq n sabia direito o que tava fazendo kk
                    itemBuilder: (context) =>
                    <PopupMenuEntry<OrderOptions>>[
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
                  TextButton(onPressed: (){
                    _showLeitorQrPage();
                  }, child: Icon(Icons.qr_code))
                ],
                bottom: TabBar(
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
                  _showCadastroPage();
                },
                child: Icon(Icons.add),
                //backgroundColor: Color.fromARGB(255, 255, 166, 78),
              ),
              body: cultivos.length == 0? Center(
                child: Text("Nenhum Registro"),
              ) : TabBarView(
                children: [
                  ListView.builder(

                    padding: EdgeInsets.all(10.0),
                    itemCount: cultivos.length,
                    itemBuilder: (context, index) {
                      return _createCard(context, index);
                    },

                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: cultivos.length,
                    itemBuilder: (context, index) {
                      return _createCard(context, index);
                    },

                  )
                ],
              ),
            );
          },
        )
    );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(

      onTap: () {
        _showCaixasPage(cultivos[index].id,);
      },

      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(

                  //shape: BoxShape.circle,

                    image: DecorationImage(
                        image: cultivos[index].image != null ?
                        FileImage(File(cultivos[index].image)) :
                        AssetImage("images/person.png")
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarTexto(cultivos[index].nome) ?? "",
                      overflow: TextOverflow.fade,
                      //verificação inutil, já que, é impossivel salvar sem o nome
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: " + cultivos[index].data ?? "sem data",
                      //cultivos[index].data ?? "sem data",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      //"Descrição: " + meliponarios[index].descricao ?? "",
                      cultivos[index].descricao ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                //pedir para o professor pq n tá funcionando

                children: [
                  IconButton(
                    icon: Icon(Icons.bar_chart),
                    onPressed: (){
                      _showDashboardMeliponarioPage(cultivos[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
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
        MaterialPageRoute(builder: (context) => CaixasPage(idApiario: id,)));

  }

  void _showCadastroPage({Meliponario meliponario}) async {
    final recMeliponario = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        CadastroMeliponarioPage(meliponario: meliponario, helper: helper, cultivo: _tabAtual,))
    );

    if (recMeliponario != null) {
      if (meliponario != null) {
        await helper.updateMeliponario(recMeliponario);
      } else {
        await helper.saveMeliponario(recMeliponario);
      }

    }
    print("cultivo: ");
    print(recMeliponario.cultivo);

    _getAllMeliponarios();

  }

  void _showDashboardMeliponarioPage(Meliponario meliponario) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardMelponariosPage(meliponario: meliponario)));
  }

  void _getAllMeliponarios() {
    helper.getMeliponariosPorCultivo(_tabAtual).then((list) {
      setState(() {
        cultivos = list;
      });
    });
  }

  void _separarPorCultivo  (){
    List<Meliponario> aux = new List();
    for(Meliponario m in cultivos){
      if(m.cultivo == _tabAtual){
        aux.add(m);
      }
    }
    cultivos = aux;
  }

  void _ordenarLista(OrderOptions resultado) {
    switch (resultado) {
      case OrderOptions.orderaz:
        cultivos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderdc:
        cultivos.sort((a, b) {
          return a.data.toLowerCase().compareTo(
              b.data.toLowerCase()); //formatar de String para DataTime
        });
        break;
    }
    setState(() {

    });
  }

  
  String _formatarTexto(String texto){
    if(texto.length > 15){
      texto = texto.substring(0, 14);
      texto += "...";
    }

    return texto;
  }

  void _showLeitorQrPage() async{
    String id = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeitorPage()));
  }
}
