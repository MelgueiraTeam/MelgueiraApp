import 'package:flutter/material.dart';

class CadastroAlimentacao extends StatefulWidget {

  @override
  _CadastroAlimentacaoState createState() => _CadastroAlimentacaoState();
}

class _CadastroAlimentacaoState extends State<CadastroAlimentacao> {
  Alimentacoes _alimentacoes = Alimentacoes.proteica;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar nova alimentação"),
        backgroundColor: Color.fromARGB(255, 255, 166, 78),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Peso da alimentação (Em kg)",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                  border: OutlineInputBorder(),
                ),
              ),
              RadioListTile(
                  title: Text("Energética"),
                  value: Alimentacoes.energica,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes value){
                    setState(() {
                      _alimentacoes = value;
                    });
                  }
              ),
              RadioListTile(
                  title: Text("Protéica"),
                  value: Alimentacoes.proteica,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes value){
                    setState(() {
                      _alimentacoes = value;
                    });
                  }
              ),
              RadioListTile(
                  title: Text("Mista"),
                  value: Alimentacoes.mista,
                  groupValue: _alimentacoes,
                  onChanged: (Alimentacoes value){
                    setState(() {
                      _alimentacoes = value;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
      ),
    );
  }
}

enum Alimentacoes{proteica, energica, mista}
