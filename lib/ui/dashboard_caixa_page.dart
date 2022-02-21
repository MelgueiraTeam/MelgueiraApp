import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/grafico_tempo_real/real_time.dart';

class DashboardCaixasPage extends StatefulWidget {
  Caixa? caixa;

  DashboardCaixasPage({this.caixa});

  @override
  _DashboardCaixasPageState createState() => _DashboardCaixasPageState();
}

class _DashboardCaixasPageState extends State<DashboardCaixasPage> {
  List<charts.Series<Task, String>> _seriesPieData = <charts.Series<Task, String>>[];
  List<charts.Series<ProducaoAnual, String>> _seriesList = <charts.Series<ProducaoAnual, String>>[];

  MeliponarioHelper _helper = MeliponarioHelper();
  double? porcentagem;

  @override
  void initState() {
    super.initState();

    _createDadosTemperaturaUmidade();

    Future.delayed(Duration.zero, () async {
      await _helper.getPorcentagemProducaoCaixa(widget.caixa!, widget.caixa!.idMeliponario!).then((value) async {
        porcentagem = value;
        await _generatorData().then((value) async {
          await _createSampleData().then((value) async {});
        });
      });
    });
    //print(_seriesList.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(
                icon: Icon(Icons.show_chart),
              ),
            ],
          ),
          title: Text("Dashboard " + widget.caixa!.nome!),
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
                            "Produção: " + widget.caixa!.nome!,
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
                    child: Text("Sem dados"),
                  ),
            _seriesList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Produção anual: " + widget.caixa!.nome!,
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
                  ),
            GraficosRealTime(widget.caixa!.id!)
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
      await _helper.getProducaoAnualCaixa(widget.caixa!.id!).then((value) async {
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

  List<charts.Series<Dados, int>> _createDadosTemperaturaUmidade() {
    var temperatura = [
      Dados(27, 19, 0),
      Dados(25, 19, 1),
      Dados(34, 19, 2),
      Dados(30, 19, 3),
      Dados(26, 19, 4),
    ];

    var umidade = [
      Dados(27, 50, 0),
      Dados(27, 79, 1),
      Dados(27, 83, 2),
      Dados(27, 67, 3),
      Dados(27, 90, 4),
    ];

    return [
      charts.Series<Dados, int>(
          id: 'temperatura',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          //areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
          data: temperatura,
          domainFn: (Dados dados, _) => dados.segundo,
          measureFn: (Dados dados, _) => dados.temperatura),
      charts.Series<Dados, int>(
          id: 'umidade',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          //areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter, não funcionou como eu queria ;-;
          data: umidade,
          domainFn: (Dados dados, _) => dados.segundo,
          measureFn: (Dados dados, _) => dados.umidade)
    ];
  }

  Future _generatorData() async {
    double? porcentagem;
    Caixa caixa = widget.caixa!;

    await _helper.getPorcentagemProducaoCaixa(widget.caixa!, widget.caixa!.idMeliponario!).then((value) async {
      porcentagem = value;

      porcentagem = double.parse(porcentagem!.toStringAsFixed(2));
      double resto = 100 - porcentagem!;
      resto = double.parse(resto.toStringAsFixed(2));

      var pieData = [
        Task("Produção " + caixa.nome!, porcentagem!, const Color(0xffb74093)),
        Task("Poducão Total", resto, const Color(0xff555555))
      ];

      _seriesPieData.add(charts.Series(
        data: pieData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.porcentagem,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily task',
        labelAccessorFn: (Task row, _) => '${row.porcentagem}',
      ));
    });
  }
}

class Dados {
  double temperatura;
  double umidade;
  int segundo; //xuncho

  Dados(this.temperatura, this.umidade, this.segundo);
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
