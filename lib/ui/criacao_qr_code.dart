import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share/share.dart';

class QrCodeGenerator extends StatefulWidget {
  int idCaixa;
  QrCodeGenerator({this.idCaixa});

  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {

  CustomPaint qr;

  @override
  Widget build(BuildContext context) {
    final message =
    // ignore: lines_longer_than_80_chars
        widget.idCaixa.toString();

    final qrFutureBuilder = CustomPaint(
      size: Size.square(280.0),
      painter: QrPainter(
        color: Color(0xff000000),
        emptyColor: Color(0xffffffff),
        data: message,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xff000000),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: Color(0xff000000),
        ),
        // size: 320.0,
        embeddedImage: null,
        embeddedImageStyle: null,
        ),
      );

    qr = qrFutureBuilder;

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: RaisedButton(
                  onPressed: _salvar,
                  child: Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('images/logo.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  _salvar() async{

    String path = await createQrPicture();

    await Share.shareFiles(
        [path],
        mimeTypes: ["image/png"],
        subject: 'My QR code',
        text: 'Please scan me'
    );

    final success = await GallerySaver.saveImage(path);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: success ? Text('Image saved to Gallery') : Text('Error saving image'),
    ));

  }

  Future<String> createQrPicture() async {

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';

    QrPainter qrPainter = qr.painter;


    final picData = await qrPainter.toImageData(2048.0, format: ui.ImageByteFormat.png );
    await writeToFile(picData, path);
    return path;
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }


}
