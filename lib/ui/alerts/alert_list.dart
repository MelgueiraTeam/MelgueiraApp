import 'package:flutter/material.dart';
import 'package:melgueira_app/entidades/banco_dados/alerta.dart';

class AlertList extends StatefulWidget {
  final List<Alerta> listaAlertas;
  final Future Function(String id) fnDeletaAlertas;
  final Function(Alerta objAlerta) fnAbreFormularioEdicao;

  const AlertList(this.listaAlertas, this.fnDeletaAlertas, this.fnAbreFormularioEdicao, {Key? key}) : super(key: key);

  @override
  AlertListState createState() => AlertListState();
}

class AlertListState extends State<AlertList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ListView.builder(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.listaAlertas.length,
            itemBuilder: (context, index) {
              final tr = widget.listaAlertas[index];

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    title: Text("Código:  ${tr.id}"),
                    subtitle: Text("Descrição:  ${tr.descricao}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.fnAbreFormularioEdicao(tr);
                          },
                          icon: const Icon(Icons.edit, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.fnDeletaAlertas(tr.id.toString()).then((value) {

                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        )
                      ],
                    )),
              );
            }),
      ],
    ));
  }
}
