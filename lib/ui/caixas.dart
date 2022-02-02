import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/cadastroCaixaPage.dart';
import 'package:prototipo_01/ui/dashboard_caixa_page.dart';
import 'package:prototipo_01/ui/detalhesCaixaPage.dart';
import 'package:prototipo_01/ui/leitor_qr_code.dart';

import 'entidades/config_json.dart';

enum OrderOptions { orderaz, orderdc }

class CaixasPage extends StatefulWidget {

  int idApiario;
  
  CaixasPage({this.idApiario});
  
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caixas"),
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
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showCadastroCaixaPage(idApiario: widget.idApiario);
        },
        child: Icon(Icons.add),
        //backgroundColor: Color.fromARGB(255, 255, 166, 78),
      ),
      body: caixas.length == 0? Center(
        child: Text("Nenhum Registro"),
      ) : ListView.builder(
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
        _showDetalhesCaixaPage2(caixa: caixas[index]);
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
                        _formatarTexto(caixas[index].nome)?? "",
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
                        icon: Icon(Icons.bar_chart),
                        onPressed: (){
                          ConfigJson.idCaixa = caixas[index].id.toString();
                          _showDashboardPage(caixas[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
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
        context, MaterialPageRoute(builder: (context) => DetalhesCaixaPage(caixa: caixa,)));
  }




  void _showLeitorQrPage() async{
    String id = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeitorPage()));
  }

  void _showDashboardPage(Caixa caixa) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardCaixasPage(caixa: caixa,)));
  }

  void _showCadastroCaixaPage({Caixa caixa, int idApiario}) async{
    final recCaixa = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CadastroCaixaPage(caixa: caixa, helper: helper, idApiario: idApiario,))
    );

    if(recCaixa != null){
      if(caixa != null){
        await helper.upadateCaixa(recCaixa);
      }else{
        await helper.saveCaixa(recCaixa);
      }
    }
    _getAllCaixas();
  }

  void _showDetalhesCaixaPage2({Caixa caixa, int idApiario}) async{
    final recCaixa = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetalhesCaixaPage(caixa: caixa,))
    );

    if(recCaixa != null){
      if(caixa != null){
        await helper.upadateCaixa(recCaixa);
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

  void _ordenarLista(OrderOptions resultado) {
    switch (resultado) {
      case OrderOptions.orderaz:
        caixas.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderdc:
        caixas.sort((a, b) {
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
}
