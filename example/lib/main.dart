import 'package:flutter/material.dart';
import 'package:laoocr/laoocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lao OCR Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LaoOCRScan(
      onCapture: (res) {
        print('OCR result = $res'); //List
        print('OCR img = ${res['kycImg']}'); //Uint8List
      },
      doFaceReg: true,
      onFaceReg: (data) {
        print('liveliness data = $data'); //image as base 64
      },
      showRetakeBtn: true,
      showSubmitBtn: true,
      showFaceSubmitBtn: true,
      txtSubmit: 'Submit',
      btnSubmit: () {
        print('submitt');
      },
      txtSubmitOnFace: 'Done',
      btnSubmitOnFace: () {
        print('face liveliness submit');
      },
    );
  }
}
