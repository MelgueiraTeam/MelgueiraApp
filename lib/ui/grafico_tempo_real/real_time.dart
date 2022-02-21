import 'dart:async';
import 'package:flutter/material.dart';


import 'package:melgueira_app/ui/grafico_tempo_real/melgueiraRealTime.dart';
import 'package:melgueira_app/ui/grafico_tempo_real/ninhoRealTime.dart';

class GraficosRealTime extends StatefulWidget {
  int idCaixa;
   GraficosRealTime(this.idCaixa, {Key? key}) : super(key: key);

  @override
  GraficosRealTimeState createState() => GraficosRealTimeState();
}

class GraficosRealTimeState extends State<GraficosRealTime> {

  static Future<String>? carregaDados;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Graficos em Tempo Real"),
            centerTitle: true,
            backgroundColor: Colors.blue,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Melgueira"),
                Tab(text: "Ninho")
              ],
            ),
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
          ),
          body: TabBarView(
            children: [
              MelgueiraRealTime(atualizaCarrregamento, widget.idCaixa),
              NinhoRealTime(atualizaCarrregamento, widget.idCaixa),
            ],
          ),


      ),
    );
  }

  @override
  initState() {
    super.initState();
  }

  Future atualizaCarrregamento() async {
    setState(() {
      carregaDados;
    });
}

  @override
  Future dispose() async {
    super.dispose();
  }


}
