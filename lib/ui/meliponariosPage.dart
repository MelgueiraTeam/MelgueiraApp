import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastroMeliponario.dart';
import 'package:prototipo_01/ui/caixas.dart';
import 'package:prototipo_01/ui/dashboard_meliponario_page.dart';

enum OrderOptions {orderaz, orderdc}

class TelaMeliponarios extends StatefulWidget {
  @override
  TelaMeliponariosState createState() => TelaMeliponariosState();
}

class TelaMeliponariosState extends State<TelaMeliponarios> {

  MeliponarioHelper helper = MeliponarioHelper();
  List<Meliponario> meliponarios = List();


  @override
  initState(){
    super.initState();

    _getAllMeliponarios();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        title: Text("MelgueirApp"),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(//copiei descaradamente pq n sabia direito o que tava fazendo kk
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text ("Ordenar alfabeticamente"),
                value: OrderOptions.orderaz,

              ),
              const PopupMenuItem<OrderOptions>(
                child: Text ("Ordenar por data de criação"),
                value: OrderOptions.orderdc,
              ),
            ],
            onSelected: _ordenarLista,
          ),
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
        onPressed: _showCadastroPage,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
      ),
      body: TabBarView(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: meliponarios.length,
            itemBuilder: (context, index){
              return _createCard(context, index);
            },

          ),
          ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: meliponarios.length,
            itemBuilder: (context, index){
              return _createCard(context, index);
            },

          )
        ],
      ),
    ));
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){
        _showCaixasPage(meliponarios[index].id);
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
                        image: meliponarios[index].image != null ?
                        FileImage(File(meliponarios[index].image)) :
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
                      meliponarios[index].nome ?? "",//verificação inutil, já que, é impossivel salvar sem o nome
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      //"Criado em: " + meliponarios[index].data ?? "sem data",
                      meliponarios[index].data ?? "sem data",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      //"Descrição: " + meliponarios[index].descricao ?? "",
                      meliponarios[index].descricao ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,//pedir para o professor pq n tá funcionando
                children: [
                  IconButton(
                    icon: Icon(Icons.dashboard),
                    onPressed: _showDashboardMeliponarioPage,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      _showCadastroPage(meliponario: meliponarios[index]);
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

  void _showCaixasPage(int idApiario) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CaixasPage(idApiario)));
  }

  void _showCadastroPage({Meliponario meliponario}) async{
    final recMeliponario = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroMeliponarioPage(meliponario: meliponario, helper: helper,))
    );

    if(recMeliponario != null){
      if(meliponario != null){
        await helper.updateMeliponario(recMeliponario);
      }else{
        await helper.saveMeliponario(recMeliponario);
      }
    }
      print(meliponarios.length);
      _getAllMeliponarios();

  }

  void _showDashboardMeliponarioPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMelponariosPage()));
  }

  void _getAllMeliponarios(){
    helper.getAllMeliponarios().then((list){
      setState(() {
        meliponarios = list;

      });
    });
  }

  void _ordenarLista(OrderOptions resultado){
    switch(resultado){
      case OrderOptions.orderaz:
        meliponarios.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderdc:
        meliponarios.sort((a, b) {
          return a.data.toLowerCase().compareTo(b.data.toLowerCase());//formatar de String para DataTime
        });
        break;

    }
    setState(() {

    });
  }

}
