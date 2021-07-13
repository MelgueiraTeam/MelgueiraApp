import 'package:flutter/material.dart';

class CadastroMeliponarioPage extends StatefulWidget {
  @override
  _CadastroMeliponarioPageState createState() => _CadastroMeliponarioPageState();
}

class _CadastroMeliponarioPageState extends State<CadastroMeliponarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Cadastrar Meliponário"),
        centerTitle: true,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: Container(
                width: 160.0,
                height: 160.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/person.png"))),
              ),
              onTap: (){},//é preciso ter um bd para trocar a imagem
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Nome Meliponário",
                labelStyle: TextStyle(color: Colors.deepOrange),
                border: OutlineInputBorder()
              ),
            ),
            Divider(),
            TextField(
              decoration: InputDecoration(
                  labelText: "Descrição Meliponário",
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  border: OutlineInputBorder()
              ),
            ),
            CheckboxListTile(//famoso xunxo
              title: Text("Sistema de termoregualção"),
              value: false,
              onChanged: (c){
                print(c);
              },
            ),
            CheckboxListTile(//famoso xunxo
              title: Text("Pesquisa por QR code"),
              value: false,
              onChanged: (c){
                print(c);
              },
            )
          ],
        ),
      ),
    );
  }
}
