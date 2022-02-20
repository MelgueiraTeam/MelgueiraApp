import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:melgueira_app/helpers/meliponario_helper.dart';

class DashboardMelponariosPage extends StatefulWidget {
  //const DashboardMelponariosPage({Key key}) : super(key: key);

  Meliponario? meliponario;

  DashboardMelponariosPage({Key? key, this.meliponario}) : super(key: key);

  @override
  _DashboardMelponariosPageState createState() => _DashboardMelponariosPageState();
}

class _DashboardMelponariosPageState extends State<DashboardMelponariosPage> {
  List<charts.Series<Task, String>> _seriesPieData = <charts.Series<Task, String>>[];

  List<charts.Series<ProducaoAnual, String>> _seriesList = <charts.Series<ProducaoAnual, String>>[];
  MeliponarioHelper _helper = MeliponarioHelper();
  double? porcentagem;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _helper.getPorcentagemProducaoMeliponario(widget.meliponario!.id!).then((value) async {
        porcentagem = value;
        await _generatorData().then((value) async {
          await _createSampleData().then((value) {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 166, 78),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.pie_chart),
              ),
              Tab(
                icon: Icon(Icons.insert_chart),
              ),
            ],
          ),
          title: const Text("Dashboard Meliponário"),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            porcentagem != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Produção: " + widget.meliponario!.nome!,
                            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: charts.PieChart<String>(
                              _seriesPieData,
                              animate: true,
                              animationDuration: const Duration(seconds: 1),
                              behaviors: [
                                charts.DatumLegend(
                                    outsideJustification: charts.OutsideJustification.endDrawArea,
                                    horizontalFirst: false,
                                    desiredMaxRows: 2,
                                    cellPadding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                                    entryTextStyle: const charts.TextStyleSpec(fontSize: 11))
                              ],
                              defaultRenderer: charts.ArcRendererConfig(arcWidth: 100, arcRendererDecorators: [
                                charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text("Sem dados ;-;"),
                  ),
            _seriesList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Produção anual: " + widget.meliponario!.nome!,
                            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: charts.BarChart(
                              _seriesList,
                              animate: true,
                              animationDuration: const Duration(seconds: 1),
                              behaviors: [
                                charts.ChartTitle('Mel(Em Kg)', behaviorPosition: charts.BehaviorPosition.start),
                                charts.ChartTitle('Anos', behaviorPosition: charts.BehaviorPosition.bottom),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text("Sem dados"),
                  )
          ],
        ),
      ),
    );
  }

  Future _createSampleData() async {
    List<int> anos = <int>[];
    List<double> producaoPorAno = <double>[];
    List<ProducaoAnual> dados = <ProducaoAnual>[];

    await _helper.getAnosColetas().then((value) async {
      anos = value;
      await _helper.getProducaoAnualMeliponario(widget.meliponario!.id!).then((value) async {
        producaoPorAno = value;
        for (int i = 0; i < anos.length; i++) {
          dados.add(ProducaoAnual(anos[i].toString(), producaoPorAno[i]));
        }

        setState(() {
          _seriesList = [
            charts.Series<ProducaoAnual, String>(
                id: 'Sales',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                data: dados,
                domainFn: (ProducaoAnual ano, _) => ano.ano,
                measureFn: (ProducaoAnual ano, _) => ano.quantidade)
          ];
        });
      });
    });
  }

  Future _generatorData() async {
    Meliponario? meliponario;

    await _helper.getMeliponario(widget.meliponario!.id!).then((value) async {
      meliponario = value;
      porcentagem = double.parse(porcentagem!.toStringAsFixed(2));
      double resto = 100 - porcentagem!;
      resto = double.parse(resto.toStringAsFixed(2));

      List<Task> pieData = resto.isNaN || porcentagem!.isNaN
          ? <Task>[
              Task("Produção " + meliponario!.nome!, 0, const Color(0xffb74093)),
              Task("Poducão Total", 1, const Color(0xff555555))
            ]
          : <Task>[
              Task("Produção " + meliponario!.nome!, porcentagem!, const Color(0xffb74093)),
              Task("Poducão Total", resto, const Color(0xff555555))
            ];

      setState(() {
        _seriesPieData.add(charts.Series(
          data: pieData,
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.porcentagem,
          colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (Task row, _) => '${row.porcentagem}',
        ));
      });
    });
  }
}

class Task {
  String task;
  double porcentagem;
  Color colorval;

  Task(this.task, this.porcentagem, this.colorval);
}

class ProducaoAnual {
  String ano;
  double quantidade;

  ProducaoAnual(this.ano, this.quantidade);
}
