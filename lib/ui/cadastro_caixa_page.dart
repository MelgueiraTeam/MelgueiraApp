import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melgueira_app/helpers/meliponario_helper.dart';

class CadastroCaixaPage extends StatefulWidget {
  final Caixa? caixa;
  final MeliponarioHelper? helper;
  final int? idApiario;

   const CadastroCaixaPage({Key? key, this.caixa, this.helper, this.idApiario}) : super(key: key);

  @override
  _CadastroCaixaPageState createState() => _CadastroCaixaPageState();
}

class _CadastroCaixaPageState extends State<CadastroCaixaPage> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _editado = false; //verefica se houve alteração nos dados do meliponário

  Caixa? _editedCaixa;
 // bool _excluir = false;

  @override
  void initState() {
    super.initState();

    if (widget.caixa == null) {
      _editedCaixa = Caixa();
      _editedCaixa!.data = gerarData();
      _editedCaixa!.idMeliponario = widget.idApiario;
     // _excluir = true;
    } else {
      _editedCaixa = Caixa.fromMap(widget.caixa!.toMap());

      _nomeController.text = _editedCaixa!.nome!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 166   , 78),
            title: const Text("Cadastrar caixa"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedCaixa!.nome != null && _editedCaixa!.nome!.isNotEmpty) {
                Navigator.pop(context, _editedCaixa);
              } else {
                FocusScope.of(context).requestFocus(_nomeFocus);
              }
            },
            child: const Icon(Icons.save),
            backgroundColor: const Color.fromARGB(255, 255, 166, 78),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _editedCaixa!.image != null
                                  ? FileImage(File(_editedCaixa!.image!))
                                  : const AssetImage("images/person.png") as ImageProvider)),
                    ),
                  ),
                  onTap: () {
                    var picker = ImagePicker();
                    picker.pickImage(source: ImageSource.camera).then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedCaixa!.image = file.path;
                      });
                    });
                  }, //é preciso ter um bd para trocar a imagem
                ),
                TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                        labelText: "Nome Caixa",
                        labelStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 166, 78)),
                        border: OutlineInputBorder()),
                    onChanged: (text) {
                      _editado = true;
                      setState(() {
                        _editedCaixa!.nome = text;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        //Implementar exclusão
                        widget.helper!.deleteCaixa(widget.caixa!.id!);
                        Navigator.pop(context);
                        //Navigator.pop(context);
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      //color: !_excluir ? Colors.red : Colors.grey,
                    ),
                  ),
                ),



                /*Divider(),
            Text(
              "Sistema de termoregulação",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Temperatura mínima",
                          labelStyle: TextStyle(color: Colors.deepOrange),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Temperatura máxima ",
                          labelStyle: TextStyle(color: Colors.deepOrange),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),*/ //fora do escopo do meu pfc
              ],
            ),
          ),
        ),
        onWillPop: _requestPopCaixas);
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

  Future<bool> _requestPopCaixas() {
    if (_editado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar alterações?"),
              content: const Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Sim"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  // void _showQrCodePage(int idCaixa) {
  //   Navigator.push(context,
//       MaterialPageRoute(builder: (context) => QrCodeGenerator(idCaixa: idCaixa,)));
// }

 // void _showQrConfigsConexao() {
  //   Navigator.push(context,
//      MaterialPageRoute(builder: (context) => const Configuracoes()));
// }

}
