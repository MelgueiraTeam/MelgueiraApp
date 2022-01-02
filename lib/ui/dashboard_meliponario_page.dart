import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardMelponariosPage extends StatefulWidget {
  @override
  _DashboardMelponariosPageState createState() => _DashboardMelponariosPageState();
}

class _DashboardMelponariosPageState extends State<DashboardMelponariosPage> {

  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series> _seriesList;


  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _generatorData();
    _seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 166, 78),
          bottom: TabBar(
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
          title: Text("Dashboard Meliponário"),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Produção: Meliponario01",
                        style: TextStyle( fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: charts.PieChart(
                          _seriesPieData,
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          behaviors: [
                            new charts.DatumLegend(
                              outsideJustification: charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding: new EdgeInsets.only(right: 5.0, bottom: 5.0),
                              entryTextStyle: charts.TextStyleSpec(
                                fontSize: 11
                              )
                            )
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 100,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside
                              )
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Produção anual: Meliponario01",
                        style: TextStyle( fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: charts.BarChart(
                          _seriesList,
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          behaviors: [
                            new charts.ChartTitle('Mel(Em Kg)',
                                behaviorPosition: charts.BehaviorPosition.start),
                            new charts.ChartTitle('Anos',
                                behaviorPosition: charts.BehaviorPosition.bottom),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static List<charts.Series<ProducaoAnual, String>> _createSampleData(){
    final data = [
      new ProducaoAnual('2017', 3.9),
      new ProducaoAnual('2018', 3.2),
      new ProducaoAnual('2019', 3.5),
      new ProducaoAnual('2020', 4.0),
    ];

    return[ new charts.Series<ProducaoAnual,String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: data,
        domainFn: (ProducaoAnual ano, _) => ano.ano,
        measureFn: (ProducaoAnual ano, _) =>ano.quantidade
    )];
  }

  _generatorData(){
    var pieData=[
      new Task("Produção Meliponario01", 47.5, Color(0xffb74093)),
      new Task("Poducão Total", (100 - 47.5), Color(0xff555555))
    ];

    _seriesPieData.add(
        charts.Series(
          data: pieData,
          domainFn: (Task task,_)=> task.task,
          measureFn: (Task task,_)=> task.porcentagem,
          colorFn: (Task task,_)=> charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Daily task',
          labelAccessorFn: (Task row,_)=> '${row.porcentagem}',

        )
    );
  }//os dois últimos métodos não seguem o mesmo padrão pq eu estava aprendendo
}
//dá pra fazer tudo em uma classe mas eu estava aprendendo
class Task{
  String task;
  double porcentagem;
  Color colorval;

  Task(this.task, this.porcentagem, this.colorval);
}

class ProducaoAnual{
  String ano;
  double quantidade;

  ProducaoAnual(this.ano, this.quantidade);
}