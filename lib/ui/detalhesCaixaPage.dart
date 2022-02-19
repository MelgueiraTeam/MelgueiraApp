import 'dart:io';

import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/coletas_page.dart';
import 'package:melgueira_app/ui/criacao_qr_code.dart';


import 'alerts/alertas.dart';
import 'alimentacoes_page.dart';
import 'cadastro_caixa_page.dart';

class DetalhesCaixaPage extends StatefulWidget {
  Caixa? caixa;

  DetalhesCaixaPage({Key? key, this.caixa}) : super(key: key);

  @override
  _DetalhesCaixaPageState createState() => _DetalhesCaixaPageState();
}

class _DetalhesCaixaPageState extends State<DetalhesCaixaPage> {
  int _tabAtual = 0;
  MeliponarioHelper helper = MeliponarioHelper();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes " + widget.caixa!.nome!),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 166, 78),
          bottom: TabBar(
            onTap: (index) {
              _tabAtual = index;
            },
            tabs: const [
              Tab(
                text: "Coletas",
              ),
              Tab(
                text: "Detalhes",
              ),
              Tab(
                text: "Alimentações",
              ),
              Tab(
                text: "QR_code",
              ),
              Tab(
                text: "Alertas",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ColetasPage(
              idCaixa: widget.caixa!.id!,
            ),
            //pedir ajuda pra alinhar
            Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () {
                  _showCadastroCaixaPage(caixa: widget.caixa!, idApiario: widget.caixa!.idMeliponario!);
                },
              ),
              body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 160.0,
                        height: 160.0,
                        decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                            image: DecorationImage(
                                image: widget.caixa!.image != null
                                    ? FileImage(File(widget.caixa!.image!))
                                    : const AssetImage("images/person.png") as ImageProvider)),
                      ),
                    ),
                    Text("Data de criação: " + widget.caixa!.data!)
                  ],
                ),
              ),


            ),
            AlimentacaoPage(
              idCaixa: widget.caixa!.id!,
            ),
            QrCodeGenerator(
              idCaixa: widget.caixa!.id!,
            ),
            Alertas()
          ],
        ),


      ),
    );
  }

  //Widget _criarCartaoColeta(String data, double quantidade) {
  //  return Card(
  //   child: Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: Row(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.only(left: 10.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "data: $data",
  //                 style: const TextStyle(fontSize: 18.0),
  //               ),
  //               Text(
  //                 "quantidade: $quantidade Kg",
  //                 style: const TextStyle(fontSize: 18.0),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
// );
  // }

  void _showCadastroCaixaPage({Caixa? caixa, int? idApiario}) async {
    final recCaixa = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroCaixaPage(
                  caixa: caixa!,
                  helper: helper,
                  idApiario: idApiario,
                )));

    if (recCaixa != null) {
      await helper.upadateCaixa(recCaixa);
    }
    setState(() {
      if (recCaixa != null) {
        widget.caixa = recCaixa;
      }
    });
  }
}
