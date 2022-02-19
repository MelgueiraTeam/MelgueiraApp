import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:melgueira_app/entidades/banco_dados/alerta.dart';
import 'package:melgueira_app/entidades/config_json.dart';
import 'package:melgueira_app/entidades/banco_dados/data_base.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:melgueira_app/entidades/notificacoes/service.dart';

@immutable
class AlertsForm extends StatefulWidget {
  final Future Function() fnCarregaAlertas;
  final Future Function() fnDesativaInteracaoTela;
  final Future Function() fnAtivaInteracaoTela;
  final Future Function() fnGerarNotificacao;
  final Future Function(Alerta? alertaObj) fnGeraNotificacao;
  final int codigoMaisAlto;
  Alerta? alertaObj;

  AlertsForm(this.fnCarregaAlertas, this.codigoMaisAlto, this.alertaObj, this.fnDesativaInteracaoTela,
      this.fnAtivaInteracaoTela, this.fnGeraNotificacao, this.fnGerarNotificacao,
      {Key? key})
      : super(key: key);

  @override
  State<AlertsForm> createState() => _AlertsFormState();
}

class _AlertsFormState extends State<AlertsForm> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  TextEditingController tecDescricao = TextEditingController();
  TextEditingController tecTempMin = TextEditingController();
  TextEditingController tecTempMax = TextEditingController();

  String textoCodigo = "";
  String tituloForm = "";
  Widget geraAlertaNotificacao = const SizedBox();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              tituloForm,
              style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border.all(color: Color(Colors.amber.value), width: 2)),
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Código Alerta: $textoCodigo",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: tecDescricao,
              decoration: const InputDecoration(
                  fillColor: Colors.blue,
                  label: Text(
                    "Descrição:",
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: tecTempMin,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  fillColor: Colors.blue,
                  label: Text(
                    "Temperatura Minima:",
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: tecTempMax,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  fillColor: Colors.blue,
                  label: Text(
                    "Temperatura Maxima:",
                    style: TextStyle(color: Colors.blue),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: geraAlertaNotificacao),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        widget.fnDesativaInteracaoTela();

                        enviaDadosFormulario().then((value) async {
                          if (value != false) {
                            await widget.fnGeraNotificacao(widget.alertaObj);
                          }
                          await widget.fnAtivaInteracaoTela();
                        }).then((value) {
                          widget.alertaObj = null;
                        });
                      },
                      child: const Text("Gravar")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar")),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 200, 0, 200))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    tecDescricao.text = "";
    tecTempMin.text = "";
    tecTempMax.text = "";
    super.dispose();
  }

  @override
  initState() {
    if (widget.alertaObj != null) {
      tituloForm = "Edição de Alerta";
      textoCodigo = widget.alertaObj!.id.toString();
      tecDescricao.text = widget.alertaObj!.descricao!;
      tecTempMin.text = widget.alertaObj!.tempMin!.toString();
      tecTempMax.text = widget.alertaObj!.tempMax!.toString();

      geraAlertaNotificacao = widget.alertaObj != null
          ? ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(Colors.amber.value)),
              onPressed: () async {
                  Service().showNotification(
                      1,
                      "Alerta MelgueiraBox",
                      "A caixa do id = ${ConfigJson.idCaixa}, excedeu o intervalo de temperatura definido no alerta de código: " +
                          widget.alertaObj!.id.toString() +
                          " !");

              },
              child:  Text("Testar Notificação", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),))
          : const SizedBox();
    } else {
      tituloForm = "Cadastro de Alerta";
      textoCodigo = widget.codigoMaisAlto.toString();
    }

    super.initState();
  }

  Future<bool> enviaDadosFormulario() async {
    if (tecDescricao.text == "" || tecTempMax.text == "" || tecTempMin.text == "") {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cadastro de Alertas'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("Preencha os campos corretamente!"),
                  ],
                ),
              ),
            );
          });
      return false;
    } else {
      Navigator.of(context).pop();
      if (widget.alertaObj == null) {
        await DataBase.saveAlerta(tecDescricao.text, double.parse(tecTempMin.text), double.parse(tecTempMax.text), ConfigJson.idCaixa)
            .then((value) async {
          await widget.fnCarregaAlertas();
        });
      } else {
        await DataBase.updateAlerta(
                widget.alertaObj!.id, tecDescricao.text, double.parse(tecTempMin.text), double.parse(tecTempMax.text))
            .then((value) async {
          await widget.fnCarregaAlertas();
        });
      }
    }

    return true;
  }
}
