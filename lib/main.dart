import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

void main() =>
    runApp(MaterialApp(home: ScannerIA(), debugShowCheckedModeBanner: false));

class ScannerIA extends StatefulWidget {
  @override
  State<ScannerIA> createState() => _ScannerIAState();
}

class _ScannerIAState extends State<ScannerIA> {
  String textoDetectado = "Toma una foto para que la IA lea";
  File? imagen;

  Future<void> escanear() async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;
    setState(() {
      imagen = File(foto.path);
      textoDetectado = "La IA está leyendo...";
    });
    final inputImage = InputImage.fromFilePath(foto.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final resultado = await textRecognizer.processImage(inputImage);
    setState(() {
      textoDetectado =
          resultado.text.isEmpty ? "No se detectó texto" : resultado.text;
    });
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Mi App con IA"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          if (imagen != null) Image.file(imagen!, height: 250),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: escanear,
            icon: Icon(Icons.camera_alt),
            label: Text("ESCANEAR CON IA"),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(textoDetectado, style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
