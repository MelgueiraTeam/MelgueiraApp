import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:melgueira_app/telas/inicio/home_page.dart';
import 'package:melgueira_app/telas/configuracoes/configuracoes.dart';
import 'package:melgueira_app/telas/grafico_passado/grafico_passado.dart';
import 'package:melgueira_app/telas/grafico_tempo_real/real_time.dart';
import 'package:melgueira_app/telas/alerts/alertas.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],

        routes: {
      "/": (context) => const HomePage(),
      "/configuracoes": (context) => const Configuracoes(),
      "/graficosRealTime": (context) => const GraficosRealTime(),
      "/graficosTempoPassado": (context) => const GraficosAntigos(),
      "/alertas": (context) => const Alertas()
    }, initialRoute: "/");
  }
}
