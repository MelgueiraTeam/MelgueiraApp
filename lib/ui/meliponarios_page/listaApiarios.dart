import 'dart:io';
import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/caixas.dart';
import 'package:melgueira_app/ui/dashboard_meliponario_page.dart';

class ListaApiarios extends StatefulWidget {
  Function(int) atualizaTabAtual;
  Future Function({Meliponario? meliponario}) showCadastroPage;
  List<Meliponario> listaApiario;

  ListaApiarios(this.atualizaTabAtual, this.showCadastroPage, this.listaApiario, {Key? key}) : super(key: key);

  @override
  _ListaApiariosState createState() => _ListaApiariosState();
}

class _ListaApiariosState extends State<ListaApiarios> {
  MeliponarioHelper helper = MeliponarioHelper();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      widget.atualizaTabAtual(0);
      await _getAllApiarios().then((value) async {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.listaApiario.isEmpty
        ? const Center(
            child: Text("Nenhum Apiario Encontrado!"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: widget.listaApiario.length,
            itemBuilder: (context, index) {
              return _createCard(context, index);
            },
          );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showCaixasPage(
          widget.listaApiario[index].id!,
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
                        image: widget.listaApiario[index].image != null
                            ? FileImage(File(widget.listaApiario[index].image!))
                            : const AssetImage("images/person.png") as ImageProvider)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarTexto(widget.listaApiario[index].nome!),

                      overflow: TextOverflow.fade,
                      //verificação inutil, já que, é impossivel salvar sem o nome
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: " + widget.listaApiario[index].data!,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      _formatarTexto(widget.listaApiario[index].descricao),
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      _showDashboardMeliponarioPage(widget.listaApiario[index]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await widget.showCadastroPage(meliponario: widget.listaApiario[index]).then((value) async {
                        await _getAllApiarios();
                      });
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

  Future _showDashboardMeliponarioPage(Meliponario meliponario) async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardMelponariosPage(meliponario: meliponario)))
        .then((value) async {
      _getAllApiarios();
    });
  }

  Future _getAllApiarios() async {
    await helper.getApiariosPorCultivo().then((list) async {
      setState(() {
        widget.listaApiario = list;
      });
    });
  }

  String _formatarTexto(String? texto) {
    if (texto == null) {
      texto = "";
    } else if (texto.length > 15) {
      texto = texto.substring(0, 14);
      texto += "...";
    }

    return texto;
  }
}
