import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';
import 'package:melgueira_app/ui/cadastro_alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {
  final int? idCaixa;

  const AlimentacaoPage({Key? key, this.idCaixa}) : super(key: key);

  @override
  _AlimentacaoPageState createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  List<Alimentacao> alimentacoes = <Alimentacao>[];
  MeliponarioHelper helper = MeliponarioHelper();

  @override
  void initState() {
    super.initState();
    _getAllAlimentacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroAliementacaoPage,
        child: const Icon(Icons.add),
      ),
      body: alimentacoes.isEmpty ? const Center(
        child: Text("Nenhuma alimentação registrada"),
      ) : ListView.builder(
          itemCount: alimentacoes.length,
          itemBuilder: (context, index){
            return _createCardAlimentacao(context, index);
          }
      ),
    );
  }

  Widget _createCardAlimentacao(BuildContext context, int index) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alimentação dia: " + alimentacoes[index].data!,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              alimentacoes[index].quantidade.toString() + "Kg",
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              _gerarNomeTipoAlimentacao(alimentacoes[index].tipo!),
              //alimentacoes[index].tipo.toString(),
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _gerarNomeTipoAlimentacao(int tipo){
    String nomeTipo;

    if(tipo == 0){
      nomeTipo = "Energética";
    }else if(tipo == 1){
      nomeTipo = "Protéica";
    }else{
      nomeTipo = "Mista";
    }

    return nomeTipo;
  }

  void _showCadastroAliementacaoPage() async {
    final recAlimentacao = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CadastroAlimentacao(idCaixa: widget.idCaixa,)));

    if (recAlimentacao != null) {
      helper.saveAlimentacao(recAlimentacao);
    }
    _getAllAlimentacoes();
  }

  void _getAllAlimentacoes() {
    helper.getAllAlimwntacaoesPorCaixa(widget.idCaixa!).then((list) {
      setState(() {
        alimentacoes = list;
      });
    });
  }
}
