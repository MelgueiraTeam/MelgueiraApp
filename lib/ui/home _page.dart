import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastroMeliponario.dart';
import 'package:prototipo_01/ui/caixas.dart';
import 'package:prototipo_01/ui/dashboard_meliponario_page.dart';

enum OrderOptions {orderaz, orderdc}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MeliponarioHelper helper = MeliponarioHelper();
  List<Meliponario> meliponarios = List();


  @override
  initState(){
    super.initState();

    _getAllMeliponarios();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meliponários"),
        backgroundColor: Colors.deepOrange,
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
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: meliponarios.length,
        itemBuilder: (context, index){
          return _createCard(context, index);
        },

      ),
    );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: _showCaixasPage,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
                crossAxisAlignment: CrossAxisAlignment.end,
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

  void _showCaixasPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CaixasPage()));
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
      _getAllMeliponarios();
    }
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
