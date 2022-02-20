import 'dart:io';
import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/caixas.dart';
import 'package:melgueira_app/ui/dashboard_meliponario_page.dart';

class ListaMeliponarios extends StatefulWidget {
  Function(int) atualizaTabAtual;
  Future Function({Meliponario? meliponario}) showCadastroPage;
  List<Meliponario> listaMeliponario;

  ListaMeliponarios(this.atualizaTabAtual, this.showCadastroPage, this.listaMeliponario, {Key? key}) : super(key: key);

  @override
  ListaMeliponariosState createState() => ListaMeliponariosState();
}

class ListaMeliponariosState extends State<ListaMeliponarios> {
  MeliponarioHelper helper = MeliponarioHelper();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      widget.atualizaTabAtual(1);
      await getAllMeliponarios().then((value) async {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.listaMeliponario.isEmpty
        ? const Center(
            child: Text("Nenhum Meliponario Encontrado!"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: widget.listaMeliponario.length,
            itemBuilder: (context, index) {
              return _createCard(context, index);
            },
          );
  }

  Widget _createCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showCaixasPage(
          widget.listaMeliponario[index].id!,
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
                        image: widget.listaMeliponario[index].image != null
                            ? FileImage(File(widget.listaMeliponario[index].image!))
                            : const AssetImage("images/person.png") as ImageProvider)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarTexto(widget.listaMeliponario[index].nome!),

                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Criado em: " + widget.listaMeliponario[index].data!,
                      //cultivos[index].data ?? "sem data",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      _formatarTexto(widget.listaMeliponario[index].descricao),
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
                      _showDashboardMeliponarioPage(widget.listaMeliponario[index]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      widget.showCadastroPage(meliponario: widget.listaMeliponario[index]).then((value) async {
                        await getAllMeliponarios();
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

  Future getAllMeliponarios() async {
    await helper.getMeliponariosPorCultivo().then((list) async {
      setState(() {
        widget.listaMeliponario = list;
      });
    });
  }

  void _showCaixasPage(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CaixasPage(
                  idApiario: id,
                )));
  }

  Future _showDashboardMeliponarioPage(Meliponario meliponario) async{
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMelponariosPage(meliponario: meliponario))).then((value) async {
          await getAllMeliponarios();
    });
  }

  String _formatarTexto(String? texto) {
    if(texto == null) {
      texto = "";
    } else if (texto.length > 15) {
      texto = texto.substring(0, 14);
      texto += "...";
    }

    return texto;
  }
}
