import 'package:flutter/material.dart';
import 'package:prototipo_01/ui/cadastroCaixaPage.dart';
import 'package:prototipo_01/ui/dashboard_caixa_page.dart';
import 'package:prototipo_01/ui/detalhesCaixaPage.dart';

enum OrderOptions { orderaz, orderdc }

class CaixasPage extends StatefulWidget {
  @override
  _CaixasPageState createState() => _CaixasPageState();
}

class _CaixasPageState extends State<CaixasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caixas"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar alfabeticamente"),
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por data de criação"),
              ),
              const PopupMenuItem(
                child: Text("Ordenar por temperatura(crescente)"),
              ),
              const PopupMenuItem(
                child: Text("Ordenar por temperatura(decrescente)"),
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
        children: [
          Expanded(
            child: _createCard("Caixa 01", "data", "30°"),
          ),
          _createCard("Caixa 02", "data", "27°")
        ],
      ),
    );
  }

  Widget _createCard(String nome, String data, String temperatura) {
    return GestureDetector(
      onTap: _showDetalhesCaixaPage,
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
                        "Temperatura: $temperatura",
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
                        onPressed: _showDashboardPage,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),

        ),
      ),
    );
  }

  void _showCadastroPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroCaixaPage()));
  }

  void _showDashboardPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardCaixasPage()));
  }

  void _showDetalhesCaixaPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetalhesCaixaPage()));
  }
}
