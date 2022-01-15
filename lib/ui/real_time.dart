// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:melgueira_app/entidades/dataBase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prototipo_01/helpers/boxMelgueira.dart';
import 'package:prototipo_01/helpers/dataBase.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficosRealTime extends StatefulWidget {
  const GraficosRealTime({Key key}) : super(key: key);

  @override
  _GraficosRealTimeState createState() => _GraficosRealTimeState();
}

class _GraficosRealTimeState extends State<GraficosRealTime> {
  double temperaturaNinho = 0;
  double umidadeNinho = 0;

  static String leitura = "";
  static List<boxMelgueira> chartData = <boxMelgueira>[];
  static List<boxMelgueira> teste = <boxMelgueira>[];
   ChartSeriesController _chartSeriesController;
  static double time = 10;

  @override
  void initState() {
    chartData = <boxMelgueira>[];
    teste = <boxMelgueira>[];

    super.initState();
    lerDados();
    getCharData();

    Timer.periodic(const Duration(seconds: 1), updateDataSource);



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(
             width: double.infinity,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                   child: Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.fromLTRB(10, 00, 10, 000),
                         child: Text("Temperatura:  "),
                       ),
                       Container(
                           margin:
                           EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                           decoration: BoxDecoration(
                               border: Border.all(
                                   color: Color(Colors.red.value), width: 2)),
                           padding: EdgeInsets.all(8),
                           child: Text(temperaturaNinho.toString() + " °C", style: TextStyle(fontWeight: FontWeight.bold),)),
                     ],
                   )),
             ),
           ),
           Container(
             width: double.infinity,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                   child: Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.fromLTRB(10, 00, 10, 000),
                         child: Text("Umidade:         "),
                       ),
                       Container(
                           margin:
                           EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                           decoration: BoxDecoration(
                               border: Border.all(
                                   color: Color(Colors.red.value), width: 2)),
                           padding: EdgeInsets.all(8),
                           child: Text(umidadeNinho.toString() + " UR", style: TextStyle(fontWeight: FontWeight.bold),)),
                     ],
                   )),
             ),
           ),
           Column(
             children: [
               Center(
                 child: SfCartesianChart(
                   series: <LineSeries<boxMelgueira, double>>[
                     LineSeries<boxMelgueira, double>(
                       onRendererCreated: (ChartSeriesController controller) {
                         _chartSeriesController = controller;
                       },
                       dataSource: chartData,
                       color: const Color.fromRGBO(192, 108, 132, 1),
                       xValueMapper: (boxMelgueira sales, _) => sales.time,
                       yValueMapper: (boxMelgueira sales, _) =>
                       sales.temperatura_ninho,
                     )
                   ],
                   primaryXAxis: NumericAxis(
                     majorGridLines: const MajorGridLines(width: 0),
                     edgeLabelPlacement: EdgeLabelPlacement.shift,
                     interval: 2,
                     title: AxisTitle(text: 'Tempo (s)'),
                   ),
                   primaryYAxis: NumericAxis(
                     majorGridLines: const MajorGridLines(width: 0),
                     edgeLabelPlacement: EdgeLabelPlacement.shift,
                     majorTickLines: const MajorTickLines(size: 0),
                     title: AxisTitle(text: 'Temperatura (°C)'),
                   ),
                 ),
               ),
               Center(
                 child: SfCartesianChart(
                   series: <LineSeries<boxMelgueira, double>>[
                     LineSeries<boxMelgueira, double>(
                       onRendererCreated: (ChartSeriesController controller) {
                         _chartSeriesController = controller;
                       },
                       dataSource: chartData,
                       color: const Color.fromRGBO(192, 108, 132, 1),
                       xValueMapper: (boxMelgueira sales, _) => sales.time,
                       yValueMapper: (boxMelgueira sales, _) =>
                       sales.umidade_ninho,
                     )
                   ],
                   primaryXAxis: NumericAxis(
                     majorGridLines: const MajorGridLines(width: 0),
                     edgeLabelPlacement: EdgeLabelPlacement.shift,
                     interval: 2,
                     title: AxisTitle(text: 'Tempo (s)'),
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
         ],
       ),
      )
    );
  }

  Future updateDataSource(Timer timer) async {
    time++;

    await DataBase.pegaDadosTemperatura().then((value) {
      teste = value;

      teste.forEach((element) {
        element.time = time;
        print("Tempo: " + time.toString());

        setState(() {
          umidadeNinho = element.umidade_ninho;
          temperaturaNinho = element.temperatura_ninho;
        });

        print("Temperatura: " + element.temperatura_ninho.toString());

        chartData.add(element);
      });

      setState(() {
        if (time >= 60) {
          chartData = <boxMelgueira>[];
          time = 0;
          _chartSeriesController.updateDataSource(
              addedDataIndex: chartData.length - 1, removedDataIndex: 0);
        } else if (chartData.length > 5) {
          chartData.removeAt(0);
          _chartSeriesController.updateDataSource(
              addedDataIndex: chartData.length - 1, removedDataIndex: 0);
        }
      });
    });
  }

  Future lerDados() async {
    await _readData().then((value) {
      leitura = value;
      print("Leitura: " + leitura.toString());
      Map<String, dynamic> teste = jsonDecode(leitura);
      print("Teste: " + teste.toString());
      DataBase.objBanco = DataBase.fromJson(teste);
      DataBase.objBanco.testaConexao();
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/config.json");
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return "erro";
    }
  }

  Future getCharData() async {
    DataBase.pegaDadosTemperatura10().then((value) {
      chartData = value;

      setState(() {
        chartData;
      });
    });
  }
}