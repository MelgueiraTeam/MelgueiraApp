import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.height * 0.40,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.bar_chart,
                      size: MediaQuery.of(context).size.height * 0.20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/graficosRealTime");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.height * 0.40,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.warning_amber_outlined,
                      size: MediaQuery.of(context).size.height * 0.20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/alertas");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.height * 0.40,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.history,
                      size: MediaQuery.of(context).size.height * 0.20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/graficosTempoPassado");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.height * 0.40,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.settings,
                      size: MediaQuery.of(context).size.height * 0.20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/configuracoes");
                    },
                  ),
                ),
              ),

            ],
          ),
        ));

  }
}
