import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/cadastroMeliponario.dart';
import 'package:prototipo_01/ui/caixas.dart';
import 'package:prototipo_01/ui/dashboard_meliponario_page.dart';

enum OrderOptions {orderaz, orderdc}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [_createCard("Meliponario01", "19/12/2020", "descricao"),
        _createCard("Meliponario02", "10/10/2020", "descricao"),
          _createCard("Meliponario03", "17/09/2020", "descricao"),
          _createCard("Meliponario04", "03/02/2020", "descricao"),
          _createCard("Meliponario05", "29/05/2020", "descricao")],
      ),
    );
  }

  Widget _createCard(String nome, String data, String descricao) {
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
                        image: AssetImage("images/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: $data",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Descrição: $descricao",
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
                    onPressed: _showCadastroPage,
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

  void _showCadastroPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroMeliponarioPage()));
  }

  void _showDashboardMeliponarioPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMelponariosPage()));
  }
}
