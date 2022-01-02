import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastroCaixaPage.dart';
import 'package:prototipo_01/ui/dashboard_caixa_page.dart';
import 'package:prototipo_01/ui/detalhesCaixaPage.dart';

enum OrderOptions { orderaz, orderdc }

class CaixasPage extends StatefulWidget {

  int idApiario;

  CaixasPage(this.idApiario);

  @override
  _CaixasPageState createState() => _CaixasPageState();
}

class _CaixasPageState extends State<CaixasPage> {

  MeliponarioHelper helper = MeliponarioHelper();
  List<Caixa> caixas = List();

  @override
  void initState() {
    super.initState();

    _getAllCaixas();
    print("olá mundo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caixas"),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
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
        onPressed: _showCadastroCaixaPage,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: caixas.length,
        itemBuilder: (context, index){
          return _createCard(context, index);
        },

      ),
    );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){
        _showDetalhesCaixaPage(caixa: caixas[index]);
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
                          image: caixas[index].image != null ?
                          FileImage(File(caixas[index].image)) :
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
                        caixas[index].nome?? "",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Criado em: " + caixas[index].data?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Temperatura: 0°" ,//é preciso se comunicar com o pfc do bruno pra ter essa informação
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
                        onPressed: (){
                          _showCadastroCaixaPage(caixa: caixas[index]);
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

  void _showDetalhesCaixaPage({Caixa caixa}){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetalhesCaixaPage(caixa: caixa)));
  }

  void _showCadastroPage({Caixa caixa}) async{
    final recCaixa = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroCaixaPage()));

    if(recCaixa != null){
      if(caixa != null){
        await helper.updateCaixa(recCaixa);
      }else{
        await helper.saveCaixa(recCaixa);
      }
    }

    _getAllCaixas();
    print(caixas.length);
  }

  void _showDashboardPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardCaixasPage()));
  }

  void _showCadastroCaixaPage({Caixa caixa}) async{
    final recCaixa = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroCaixaPage(caixa: caixa, helper: helper, idApiario: widget.idApiario,))
    );

    if(recCaixa != null){
      if(caixa != null){
        await helper.updateCaixa(recCaixa);
      }else{
        await helper.saveCaixa(recCaixa);
      }
    }

    _getAllCaixas();

  }

  void _getAllCaixas(){
    helper.getAllCaixasApiario(widget.idApiario).then((list){
      setState(() {
        caixas = list;

      });
    });
  }
}
