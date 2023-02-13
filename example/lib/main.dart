import 'package:flutter/material.dart';
import 'package:laoocr/laoocr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lao OCR Demo',
      theme: ThemeData(
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
      showPopBack: true,
      doFaceReg: true,
      onFaceReg: (data) {
        //liveliness status is Passed means real people, Fail means fake person
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
