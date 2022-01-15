import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:prototipo_01/helpers/meliponario_helper.dart';
import 'package:prototipo_01/ui/real_time.dart';

class DashboardCaixasPage extends StatefulWidget {
  
  Caixa caixa;


  DashboardCaixasPage({this.caixa});

  @override
  _DashboardCaixasPageState createState() => _DashboardCaixasPageState();
}

class _DashboardCaixasPageState extends State<DashboardCaixasPage> {

  List<charts.Series<Task, String>> _seriesPieData = new List();
  List<charts.Series<ProducaoAnual, String>> _seriesList;
  List<charts.Series> _temperaturaUmidade;
  charts.DatumLegend datumLegend;
  
  MeliponarioHelper _helper = new MeliponarioHelper();


  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _createLegend();
    _generatorData();
    _createSampleData();
    _temperaturaUmidade = _createDadosTemperaturaUmidade();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(
                icon: Icon(Icons.show_chart),
              ),
            ],

          ),
          title: Text("Dashboard " + widget.caixa.nome),
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
                        "Produção: " + widget.caixa.nome,
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
                        "Produção anual: " + widget.caixa.nome,
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
            GraficosRealTime(),

            /*Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Temperatura e umidade: " + widget.caixa.nome,
                        style: TextStyle( fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: charts.LineChart(
                          _temperaturaUmidade,
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                            defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
                          behaviors: [
                            new charts.ChartTitle('Temperatura(C°)',
                            behaviorPosition: charts.BehaviorPosition.start),
                            new charts.ChartTitle('Tempo(s)',
                                behaviorPosition: charts.BehaviorPosition.bottom),
                            new charts.ChartTitle('Umidade(%)',
                                behaviorPosition: charts.BehaviorPosition.end),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void>_createSampleData() async{
    List<int> anos = List();
    List<double> producaoPorAno = List();
    
    anos = await _helper.getAnosColetas();

    producaoPorAno = await _helper.getProducaoAnualCaixa(widget.caixa.id);

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

  static List<charts.Series<Dados, int>> _createDadosTemperaturaUmidade(){
    var temperatura = [
      new Dados(27, 19, 0),
      new Dados(25, 19, 1),
      new Dados(34, 19, 2),
      new Dados(30, 19, 3),
      new Dados(26, 19, 4),
    ];

    var umidade = [
      new Dados(27, 50, 0),
      new Dados(27, 79, 1),
      new Dados(27, 83, 2),
      new Dados(27, 67, 3),
      new Dados(27, 90, 4),
    ];

    return [new charts.Series<Dados, int>(
        id: 'temperatura',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        //areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        data: temperatura,
        domainFn: (Dados dados, _ ) => dados.segundo,
        measureFn: (Dados dados, _ ) => dados.temperatura),
      new charts.Series<Dados, int>(
          id: 'umidade',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          //areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter, não funcionou como eu queria ;-;
          data: umidade,
          domainFn: (Dados dados, _ ) => dados.segundo,
          measureFn: (Dados dados, _ ) => dados.umidade)
    ];
  }

  _generatorData() async{
    double porcentagem = await _helper.getPorcentagemProducaoCaixa(widget.caixa, widget.caixa.idMeliponario);
    Caixa caixa = widget.caixa;

    var pieData=[
      new Task("Produção " + caixa.nome, porcentagem, Color(0xffb74093)),
      new Task("Poducão Total", (100.0 - porcentagem), Color(0xff555555))
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

class Dados{
  double temperatura;
  double umidade;
  int segundo;//xuncho

  Dados(this.temperatura, this.umidade, this.segundo);
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