// ignore_for_file: prefer_const_constructors
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:melgueira_app/entidades/banco_dados/data_base.dart';
import 'package:melgueira_app/entidades/banco_dados/media_box.dart';
import 'package:melgueira_app/entidades/config_json.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficosAntigos extends StatefulWidget {
  const GraficosAntigos({Key? key}) : super(key: key);

  @override
  _GraficosAntigosState createState() => _GraficosAntigosState();
}

class _GraficosAntigosState extends State<GraficosAntigos> {
  String textoDataInicial = 'Selecione uma Data';
  String textoDataFinal = 'Selecione uma Data';
  DateTime? dataInicial;
  DateTime? dataFinal;

  static double time = 0;

  static List<MediaBox> chartData = <MediaBox>[];
  static List<MediaBox> objGraficoTemporario = <MediaBox>[];
  static ChartSeriesController? _chartSeriesController;

  static Future<String>? carregaDados;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<String>(
                future: carregaDados,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Widget children;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    children = const SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if(snapshot.data == "") {
                    children = const SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  else if(snapshot.data == "Erro") {
                    children = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 30,
                    );
                  }
                  else if (snapshot.hasError) {
                    children = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 30,
                    );
                  } else {
                    children = const Icon(
                      Icons.check_circle_outline,
                      color: Colors.greenAccent,
                      size: 30,
                    );
                  }
                  return children;
                }),
          ),
        ],






        title: Text(
          "Grafico de Periodos Anteriores",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                elevation: 10,
                color: Colors.blueAccent,
                child: SizedBox(
                    width: double.infinity,
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Filtro de Datas",
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Card(
                              child: Column(children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                      elevation: 5,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Periodo Inicial:  ",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blueAccent,
                                            ),
                                            child: Text(
                                              textoDataInicial,
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              if (dataFinal != null) {
                                                await showDatePicker(
                                                        locale: Locale("pt"),
                                                        fieldHintText: "dd/mm/yyyy",
                                                        errorFormatText: "Formato de data inserida invalida",
                                                        cancelText: "Cancelar",
                                                        confirmText: "Confirmar",
                                                        fieldLabelText: "Insira uma Data Manualmente",
                                                        helpText: "Selecione uma Data",
                                                        context: context,
                                                        firstDate: dataFinal!.subtract(const Duration(days: 5)),
                                                        initialDate: dataFinal!.subtract(const Duration(days: 5)),
                                                        lastDate: dataFinal!)
                                                    .then((value) {
                                                  dataInicial = value;
                                                });

                                                setState(() {
                                                  if (dataInicial != null) {
                                                    textoDataInicial =
                                                        DateFormat('dd/MM/yyyy').format(dataInicial!).toString();
                                                  }
                                                });
                                              } else {
                                                await showDatePicker(
                                                        locale: Locale("pt"),
                                                        fieldHintText: "dd/mm/yyyy",
                                                        errorFormatText: "Formato de data inserida invalida",
                                                        cancelText: "Cancelar",
                                                        confirmText: "Confirmar",
                                                        fieldLabelText: "Insira uma Data Manualmente",
                                                        helpText: "Selecione uma Data",
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(2020),
                                                        lastDate: DateTime(2023))
                                                    .then((value) {
                                                  dataInicial = value;
                                                });

                                                setState(() {
                                                  if (dataInicial != null) {
                                                    textoDataInicial =
                                                        DateFormat('dd/MM/yyyy').format(dataInicial!).toString();
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                      elevation: 5,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Periodo Final:    ",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blueAccent,
                                            ),
                                            child: Text(
                                              textoDataFinal,
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              //.subtract(const Duration(days: 5))

                                              if (dataInicial != null) {
                                                await showDatePicker(
                                                        locale: Locale("pt"),
                                                        fieldHintText: "dd/mm/yyyy",
                                                        errorFormatText: "Formato de data inserida invalida",
                                                        cancelText: "Cancelar",
                                                        confirmText: "Confirmar",
                                                        fieldLabelText: "Insira uma Data Manualmente",
                                                        helpText: "Selecione uma Data",
                                                        context: context,
                                                        firstDate: dataInicial!,
                                                        initialDate: dataInicial!.add(const Duration(days: 5)),
                                                        lastDate: dataInicial!.add(const Duration(days: 5)))
                                                    .then((value) {
                                                  dataFinal = value;
                                                });

                                                setState(() {
                                                  if (dataFinal != null) {
                                                    textoDataFinal =
                                                        DateFormat('dd/MM/yyyy').format(dataFinal!).toString();
                                                  }
                                                });
                                              } else {
                                                await showDatePicker(
                                                        locale: Locale("pt"),
                                                        fieldHintText: "dd/mm/yyyy",
                                                        errorFormatText: "Formato de data inserida invalida",
                                                        cancelText: "Cancelar",
                                                        confirmText: "Confirmar",
                                                        fieldLabelText: "Insira uma Data Manualmente",
                                                        helpText: "Selecione uma Data",
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(2020),
                                                        lastDate: DateTime(2023))
                                                    .then((value) {
                                                  dataFinal = value;
                                                });

                                                setState(() {
                                                  if (dataFinal != null) {
                                                    textoDataFinal =
                                                        DateFormat('dd/MM/yyyy').format(dataFinal!).toString();
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(primary: Colors.red),
                                        child: Text("Limpar Datas"),
                                        onPressed: () {
                                          setState(() {
                                            chartData = <MediaBox>[];
                                            dataInicial = null;
                                            dataFinal = null;
                                            textoDataFinal = "Selecione uma Data";
                                            textoDataInicial = "Selecione uma Data";
                                          });
                                        },
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        child: Text("Filtrar"),
                                        onPressed: () {
                                          if (dataInicial == null) {
                                            showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Periodo Inicial'),
                                                    content: SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text("Atenção, selecione uma data inicial."),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else if (dataFinal == null) {
                                            showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Periodo Final'),
                                                    content: SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text("Atenção, selecione uma data final."),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else if (dataInicial!.isAfter(dataFinal!)) {
                                            showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Periodo Inicial'),
                                                    content: SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              "Atenção, a data inicial não pode ser maior que a data final!"),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else {
                                            //Aqui sera feito o Select
                                            setState(() {
                                              carregaDados = Future.value('');
                                            });

                                            Future.delayed(Duration.zero, () async {
                                              await ConfigJson.readConfigJson(gerarConexaoBanco: true)
                                                  .then((value) async {
                                                await DataBase.getConexao().then((value) async {
                                                  await DataBase.getDadosRelatorio(dataInicial, dataFinal)
                                                      .then((listaMedia) async {
                                                    for (MediaBox objMediaBox in listaMedia) {
                                                      debugPrint(objMediaBox.tString());
                                                      chartData.add(objMediaBox);
                                                    }

                                                    setState(() {
                                                      chartData;
                                                      carregaDados = Future.value('Carregado');
                                                    });

                                                  });
                                                });
                                              });
                                            });
                                          }
                                        },
                                      ),
                                    )),
                              ],
                            )
                          ])))
                    ]))),
            Card(
                elevation: 10,
                color: Colors.blueAccent,
                child: SizedBox(
                    width: double.infinity,
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Grafico Melgueira",
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Card(
                              child: Column(children: [
                            Column(
                              children: [
                                Center(
                                  child: SfCartesianChart(
                                    series: <LineSeries<MediaBox, DateTime>>[
                                      LineSeries<MediaBox, DateTime>(
                                        onRendererCreated: (ChartSeriesController controller) {
                                          _chartSeriesController = controller;
                                        },
                                        dataSource: chartData,
                                        color: const Color.fromRGBO(192, 108, 132, 1),
                                        xValueMapper: (MediaBox sales, _) => sales.dia,
                                        yValueMapper: (MediaBox sales, _) => sales.temperatura_melgueira,
                                      )
                                    ],
                                    primaryXAxis:  DateTimeAxis(
                                      intervalType: DateTimeIntervalType.days,
                                      majorGridLines: const MajorGridLines(width: 0),
                                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                                      title: AxisTitle(text: 'Tempo (dia)'),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      interval: 5,
                                      majorGridLines: const MajorGridLines(width: 0),
                                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                                      majorTickLines: const MajorTickLines(size: 0),
                                      title: AxisTitle(text: 'Temperatura (°C)'),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: SfCartesianChart(
                                    series: <LineSeries<MediaBox, DateTime>>[
                                      LineSeries<MediaBox, DateTime>(
                                        onRendererCreated: (ChartSeriesController controller) {
                                          _chartSeriesController = controller;
                                        },
                                        dataSource: chartData,
                                        color: const Color.fromRGBO(192, 108, 132, 1),
                                        xValueMapper: (MediaBox sales, _) => sales.dia,
                                        yValueMapper: (MediaBox sales, _) => sales.umidade_melgueira,
                                      )
                                    ],
                                    primaryXAxis: DateTimeAxis(
                                      intervalType: DateTimeIntervalType.days,
                                      majorGridLines: const MajorGridLines(width: 0),
                                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                                      title: AxisTitle(text: 'Tempo (dia)'),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      majorGridLines: const MajorGridLines(width: 0),
                                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                                      majorTickLines: const MajorTickLines(size: 0),
                                      title: AxisTitle(text: 'Umidade (°UR)'),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ])))
                    ]))),

            Card(
                elevation: 10,
                color: Colors.blueAccent,
                child: SizedBox(
                    width: double.infinity,
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Grafico Ninho",
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Card(
                              child: Column(children: [
                                Column(
                                  children: [
                                    Center(
                                      child: SfCartesianChart(
                                        series: <LineSeries<MediaBox, DateTime>>[
                                          LineSeries<MediaBox, DateTime>(
                                            onRendererCreated: (ChartSeriesController controller) {
                                              _chartSeriesController = controller;
                                            },
                                            dataSource: chartData,
                                            color: const Color.fromRGBO(192, 108, 132, 1),
                                            xValueMapper: (MediaBox sales, _) => sales.dia,
                                            yValueMapper: (MediaBox sales, _) => sales.temperatura_ninho,
                                          )
                                        ],
                                        primaryXAxis:  DateTimeAxis(
                                          intervalType: DateTimeIntervalType.days,
                                          majorGridLines: const MajorGridLines(width: 0),
                                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                                          title: AxisTitle(text: 'Tempo (dia)'),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          interval: 5,
                                          majorGridLines: const MajorGridLines(width: 0),
                                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                                          majorTickLines: const MajorTickLines(size: 0),
                                          title: AxisTitle(text: 'Temperatura (°C)'),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: SfCartesianChart(
                                        series: <LineSeries<MediaBox, DateTime>>[
                                          LineSeries<MediaBox, DateTime>(
                                            onRendererCreated: (ChartSeriesController controller) {
                                              _chartSeriesController = controller;
                                            },
                                            dataSource: chartData,
                                            color: const Color.fromRGBO(192, 108, 132, 1),
                                            xValueMapper: (MediaBox sales, _) => sales.dia,
                                            yValueMapper: (MediaBox sales, _) => sales.umidade_ninho,
                                          )
                                        ],
                                        primaryXAxis: DateTimeAxis(
                                          intervalType: DateTimeIntervalType.days,
                                          majorGridLines: const MajorGridLines(width: 0),
                                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                                          title: AxisTitle(text: 'Tempo (dia)'),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: const MajorGridLines(width: 0),
                                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                                          majorTickLines: const MajorTickLines(size: 0),
                                          title: AxisTitle(text: 'Umidade (°UR)'),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ])))
                    ]))),
          ],
        ),
      ),
    );
  }
  @override
  Future dispose() async {
    dataInicial = null;
    dataFinal = null;
    textoDataFinal = "Selecione uma Data";
    textoDataInicial = "Selecione uma Data";
    chartData = <MediaBox>[];
    super.dispose();
  }


}
