import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:prototipo_01/helpers/meliponario_helper.dart';

class DashboardMelponariosPage extends StatefulWidget {
  //const DashboardMelponariosPage({Key key}) : super(key: key);

  final Meliponario meliponario;



  DashboardMelponariosPage({this.meliponario});

  @override
  _DashboardMelponariosPageState createState() => _DashboardMelponariosPageState();
}

class _DashboardMelponariosPageState extends State<DashboardMelponariosPage> {


  List<charts.Series<Task, String>> _seriesPieData = <charts.Series<Task, String>>[];

  charts.DatumLegend datumLegend;

  List<charts.Series<ProducaoAnual, String>> _seriesList = <charts.Series<ProducaoAnual, String>>[];
  MeliponarioHelper _helper = new MeliponarioHelper();

  @override
  initState(){
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _createLegend();
      //_seriesPieData = List<charts.Series<Task, String>>();
      await _generatorData();
      await _createSampleData();
    });

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
                        "Produção: " + widget.meliponario.nome,
                        style: TextStyle( fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: charts.PieChart(
                          _seriesPieData,
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          behaviors: [
                            datumLegend,
                          ],
                          /*behaviors: [
                            new charts.DatumLegend(
                              outsideJustification: charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding: new EdgeInsets.only(right: 5.0, bottom: 5.0),
                              entryTextStyle: charts.TextStyleSpec(
                                fontSize: 11
                              )
                            )
                          ],*/
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
                        "Produção anual: " + widget.meliponario.nome,
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
   Future<void>_createSampleData() async{
    List<int> anos = List();
    List<double> producaoPorAno = List();
    //anos.add(2022);


    anos = await _helper.getAnosColetas();

    producaoPorAno = await _helper.getProducaoAnualMeliponario(widget.meliponario.id);

    List<ProducaoAnual> dados = new List();
    for(int i = 0; i < anos.length; i++){
      dados.add(new ProducaoAnual(anos[i].toString(), producaoPorAno[i]));
     }
    /*
    final data = [
      for(int i = 0; i < anos.length; i++){
        new ProducaoAnual(anos[i].toString(), producaoPorAno[i]),
      }
    ];*/

    setState(() {
      _seriesList = [ new charts.Series<ProducaoAnual,String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          data: dados,
          domainFn: (ProducaoAnual ano, _) => ano.ano,
          measureFn: (ProducaoAnual ano, _) =>ano.quantidade
      )];
    });
  }

  _generatorData() async{
    double porcentagem = await _helper.getPorcentagemProducaoMeliponario(widget.meliponario.id);
    Meliponario meliponario = await _helper.getMeliponario(widget.meliponario.id);

    porcentagem = double.parse(porcentagem.toStringAsFixed(2));
    double resto = 100 - porcentagem;
    resto = double.parse(resto.toStringAsFixed(2));

    var pieData=[
      new Task("Produção " + meliponario.nome, porcentagem, Color(0xffb74093)),
      new Task("Poducão Total", resto, Color(0xff555555))
    ];

    setState(() {
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
    });
  }

  _createLegend() async{
    datumLegend = await new charts.DatumLegend(
        outsideJustification: charts.OutsideJustification.endDrawArea,
        horizontalFirst: false,
        desiredMaxRows: 2,
        cellPadding: new EdgeInsets.only(right: 5.0, bottom: 5.0),
        entryTextStyle: charts.TextStyleSpec(
            fontSize: 11
        )
    );
  }

}

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