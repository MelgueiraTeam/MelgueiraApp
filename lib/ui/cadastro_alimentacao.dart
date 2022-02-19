import 'package:flutter/material.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';

class CadastroAlimentacao extends StatefulWidget {

  final int? idCaixa;


   const CadastroAlimentacao({Key? key, this.idCaixa}) : super(key: key);

  @override
  _CadastroAlimentacaoState createState() => _CadastroAlimentacaoState();
}

class _CadastroAlimentacaoState extends State<CadastroAlimentacao> {
  Alimentacoes _alimentacoes = Alimentacoes.proteica;
  int _valorAlimentacao = 1;

  Alimentacao? _editedAlimentacao;

  @override
  void initState() {
    super.initState();

    if(_editedAlimentacao == null){
      _editedAlimentacao = Alimentacao();
      _editedAlimentacao!.data = gerarData();
      _editedAlimentacao!.idCaixa = widget.idCaixa;
      _editedAlimentacao!.tipo = _valorAlimentacao;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar nova alimentação"),
        backgroundColor: const Color.fromARGB(255, 255, 166, 78),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Peso da alimentação (Em kg)",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                  border: OutlineInputBorder(),
                ),
                onChanged: (text){
                  setState(() {
                    _editedAlimentacao!.quantidade = double.parse(text);
                  });
                },
              ),
              RadioListTile(
                  title: const Text("Energética"),
                  value: Alimentacoes.energica,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes? value){
                    setState(() {
                      _alimentacoes = value!;
                      _valorAlimentacao = 0;
                      _editedAlimentacao!.tipo = _valorAlimentacao;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text("Protéica"),
                  value: Alimentacoes.proteica,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes? value){
                    setState(() {
                      _alimentacoes = value!;
                      _valorAlimentacao = 1;
                      _editedAlimentacao!.tipo = _valorAlimentacao;
                    });
                  }
              ),
              RadioListTile(
                  title: const Text("Mista"),
                  value: Alimentacoes.mista,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes? value){
                    setState(() {
                      _alimentacoes = value!;
                      _valorAlimentacao = 2;
                      _editedAlimentacao!.tipo = _valorAlimentacao;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if (_editedAlimentacao!.quantidade != null) {
            Navigator.pop(context, _editedAlimentacao);
          } else {
            //ocusScope.of(context).requestFocus(_qtdFocus);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  String gerarData() {
    var data = DateTime.now();
    String dataFormatada;
    int dia = data.day;
    int mes = data.month;
    int ano = data.year;

    //eu sei que é xunxu
    //no futuro usar plugins para formatar no padrão PT-BR

    if (dia < 10) {
      dataFormatada = "0$dia/";
    } else {
      dataFormatada = "$dia/";
    }

    if (mes < 10) {
      dataFormatada += "0$mes/";
    } else {
      dataFormatada += "$mes/";
    }
    dataFormatada += "$ano";
    return dataFormatada;
  }

}

enum Alimentacoes{proteica, energica, mista}
