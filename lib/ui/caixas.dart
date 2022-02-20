import 'dart:io';
import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/cadastro_caixa_page.dart';
import 'package:melgueira_app/ui/dashboard_caixa_page.dart';
import 'package:melgueira_app/ui/detalhesCaixaPage.dart';
import 'package:melgueira_app/ui/leitor_qr_code.dart';
import '../entidades/config_json.dart';

enum OrderOptions { orderaz, orderdc }

class CaixasPage extends StatefulWidget {
  int? idApiario;

  CaixasPage({Key? key, this.idApiario}) : super(key: key);

  @override
  _CaixasPageState createState() => _CaixasPageState();
}

class _CaixasPageState extends State<CaixasPage> {
  MeliponarioHelper helper = MeliponarioHelper();
  List<Caixa> caixas = <Caixa>[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _getAllCaixas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caixas"),
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
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCadastroCaixaPage(idApiario: widget.idApiario!);
        },
        child: const Icon(Icons.add),
        //backgroundColor: Color.fromARGB(255, 255, 166, 78),
      ),
      body: caixas.isEmpty
          ? const Center(
              child: Text("Nenhum Registro"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: caixas.length,
              itemBuilder: (context, index) {
                return _createCard(context, index);
              },
            ),
    );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showDetalhesCaixaPage2(caixa: caixas[index]);
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
                        image: caixas[index].image != null
                            ? FileImage(File(caixas[index].image!))
                            : const AssetImage("images/person.png") as ImageProvider)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarTexto(caixas[index].nome!),
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: " + caixas[index].data!,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const Text(
                      "Temperatura: 0°", //é preciso se comunicar com o pfc do bruno pra ter essa informação
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      ConfigJson.idCaixa = caixas[index].id.toString();
                      _showDashboardPage(caixas[index]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
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

  void _showLeitorQrPage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const LeitorPage()));
  }

  void _showDashboardPage(Caixa caixa) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardCaixasPage(
                  caixa: caixa,
                )));
  }

  Future _showCadastroCaixaPage({Caixa? caixa, int? idApiario}) async {
    dynamic recCaixa;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroCaixaPage(
                  caixa: caixa,
                  helper: helper,
                  idApiario: idApiario,
                ))).then((value) async {
      recCaixa = value;
      await _getAllCaixas();
    });

    if (recCaixa != null) {
      if (caixa != null) {
        await helper.upadateCaixa(recCaixa);
        await _getAllCaixas();
      } else {
        await helper.saveCaixa(recCaixa);
        await _getAllCaixas();
      }
    }
  }

  void _showDetalhesCaixaPage2({Caixa? caixa}) async {
    final recCaixa = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetalhesCaixaPage(
                  caixa: caixa,
                )));

    if (recCaixa != null) {
      if (caixa != null) {
        await helper.upadateCaixa(recCaixa);
      } else {
        await helper.saveCaixa(recCaixa);
      }
    }
    await _getAllCaixas();
  }

  Future _getAllCaixas() async {
    await helper.getAllCaixasApiario(widget.idApiario!).then((list) {
      setState(() {
        caixas = list;
      });
    });
  }

  Future _ordenarLista(OrderOptions resultado) async {
    switch (resultado) {
      case OrderOptions.orderaz:
        await _getAllCaixas().then((value) async {
          setState(() {
            caixas.sort((a, b) {
              return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
            });
          });
        });

        break;

      case OrderOptions.orderdc:
        await _getAllCaixas().then((value) async {
          setState(() {
            caixas.sort((a, b) {
              return a.data!.toLowerCase().compareTo(b.data!.toLowerCase());
            });
          });
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
}
