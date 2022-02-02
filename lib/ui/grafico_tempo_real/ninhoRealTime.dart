/*
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:melgueira_app/entidades/config_json.dart';
import 'package:melgueira_app/entidades/banco_dados/data_base.dart';
import 'package:melgueira_app/entidades/banco_dados/box_melgueira.dart';
import 'package:melgueira_app/telas/grafico_tempo_real/real_time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NinhoRealTime extends StatefulWidget {

  Future Function() fnAtualizaCarregamento;
   NinhoRealTime(this.fnAtualizaCarregamento, {Key? key}) : super(key: key);

  @override
  _NinhoRealTimeState createState() => _NinhoRealTimeState();
}

class _NinhoRealTimeState extends State<NinhoRealTime> {
  static double time = 0;

  double temperaturaNinho = 0;
  double umidadeNinho = 0;

  double temperaturaMelgueira = 0;
  double umidadeMelgueira = 0;

  String idCaixa = '0';

  Future<String> carregaDados;

  static List<BoxMelgueira> chartData = <BoxMelgueira>[];
  static List<BoxMelgueira> objGraficoTemporario = <BoxMelgueira>[];
  static ChartSeriesController? _chartSeriesController;
  static Timer? _timerDisparaGetDadosTemperatura;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
              elevation: 5,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 00, 10, 000),
                    child: Text("Codigo Caixa:  "),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(border: Border.all(color: Color(Colors.amber.value), width: 2)),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        idCaixa + " ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              )),



          Card(
              elevation: 10,
              color: Colors.blueAccent,
              child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ninho",
                        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Card(
                            child: Column(children: [
                              SizedBox(
                                width: double.infinity,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Card(
                                        elevation: 5,
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(10, 00, 10, 000),
                                              child: Text("Temperatura:  "),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Color(Colors.red.value), width: 2)),
                                                padding: const EdgeInsets.all(8),
                                                child: Text(
                                                  temperaturaNinho.toString() + " °C",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                )),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Card(
                                      elevation: 5,
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(10, 00, 10, 000),
                                            child: Text("Umidade:         "),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Color(Colors.blue.value), width: 2)),
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                umidadeNinho.toString() + " UR",
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              )),
                                        ],
                                      )),
                                ),
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: SfCartesianChart(
                                      series: <LineSeries<BoxMelgueira, double>>[
                                        LineSeries<BoxMelgueira, double>(
                                          onRendererCreated: (ChartSeriesController controller) {
                                            _chartSeriesController = controller;
                                          },
                                          dataSource: chartData,
                                          color: const Color.fromRGBO(192, 108, 132, 1),
                                          xValueMapper: (BoxMelgueira sales, _) => sales.time,
                                          yValueMapper: (BoxMelgueira sales, _) => sales.temperaturaNinho,
                                        )
                                      ],
                                      primaryXAxis: NumericAxis(
                                        majorGridLines: const MajorGridLines(width: 0),
                                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        interval: 1,
                                        title: AxisTitle(text: 'Tempo (s)'),
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
                                      series: <LineSeries<BoxMelgueira, double>>[
                                        LineSeries<BoxMelgueira, double>(
                                          onRendererCreated: (ChartSeriesController controller) {
                                            _chartSeriesController = controller;
                                          },
                                          dataSource: chartData,
                                          color: const Color.fromRGBO(192, 108, 132, 1),
                                          xValueMapper: (BoxMelgueira sales, _) => sales.time,
                                          yValueMapper: (BoxMelgueira sales, _) => sales.umidadeNinho,
                                        )
                                      ],
                                      primaryXAxis: NumericAxis(
                                        majorGridLines: const MajorGridLines(width: 0),
                                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        interval: 1,
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
                            ])))
                  ]))),


        ],
      ),
    );
  }

  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      GraficosRealTimeState.carregaDados = Future<String>.value('');
      await widget.fnAtualizaCarregamento();
      await ConfigJson.readConfigJson(gerarConexaoBanco: true).then((value) async{

        await DataBase.getConexao().then((value) async {
          if(value == null || value == false){
            GraficosRealTimeState.carregaDados = Future<String>.value('Erro');
            await widget.fnAtualizaCarregamento();
          } else {
            GraficosRealTimeState.carregaDados = Future<String>.value('Carregado');
            await widget.fnAtualizaCarregamento().then((value) {
              limpaGrafico();
              if (ConfigJson.idCaixa != "") {

                _timerDisparaGetDadosTemperatura = Timer.periodic(const Duration(seconds: 1), updateDataSource);
              }


            });


          }


        });

      });

    });

    super.initState();
  }

  @override
  Future dispose() async {
    GraficosRealTimeState.carregaDados = Future<String>.value('');
    debugPrint("Fechou a tela Ninho");
    chartData = <BoxMelgueira>[];
    time = 0;
    Future.delayed(Duration.zero, () async {
      await cancelaTimer().then((value) {
        if(DataBase.conn != null) {
          DataBase.conn!.close();
        }
      });
    });
    super.dispose();
  }


  Future cancelaTimer() async {
    if (_timerDisparaGetDadosTemperatura != null) {
      _timerDisparaGetDadosTemperatura!.cancel();

      debugPrint("Timer está ativo: " + _timerDisparaGetDadosTemperatura!.isActive.toString());
    }
  }

  Future limpaGrafico() async {
    time = 0;
    _chartSeriesController = null;
  }

  Future updateDataSource(Timer timer) async {
    if (time >= 60) {
      time = 0;

      if (mounted) {
        setState(() {
          chartData = <BoxMelgueira>[];
          BoxMelgueira origemPlano = BoxMelgueira(0, 0, 0, 0, 0);
          chartData.add(origemPlano);

          _chartSeriesController!.updateDataSource(removedDataIndexes: [0, 1, 2, 3, 4], addedDataIndex: 0);
        });
      }
    } else {

      await DataBase.getDadosTemperatura(idCaixa: ConfigJson.idCaixa).then((value) async{





        objGraficoTemporario = value;

        for (var element in objGraficoTemporario) {
          time++;

          element.time = time;

          debugPrint("Tempo: " + time.toString());
          debugPrint("Temperatura: " + element.temperaturaNinho.toString());

          if (mounted) {
            setState(() {
              idCaixa = ConfigJson.idCaixa;

              umidadeNinho = element.umidadeNinho;
              temperaturaNinho = element.temperaturaNinho;

              umidadeMelgueira = element.umidadeMelgueira;
              temperaturaMelgueira = element.temperaturaMelgueira;

              chartData.add(element);
            });
          }
        }

        if (chartData.length > 5) {
          if (mounted) {
            setState(() {
              chartData.removeAt(0);
              _chartSeriesController!.updateDataSource(removedDataIndex: 0, addedDataIndex: chartData.length - 1);
            });
          }
        }
      });



    }
  }
}


 */