import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_description.dart';
import 'inside_line.dart';
import 'inside_line_direction.dart';
import 'inside_line_position.dart';
import 'liveness_face.dart';
import 'main_crop.dart';
import 'result.dart';

class MaskOCRCam extends StatefulWidget {
  MaskOCRCam(
      {Key? key,
      required this.ocrType,
      this.ocrSubType,
      required this.onCapture,
      this.doFaceReg,
      this.onFaceReg,
      this.showRetakeBtn = true,
      this.txtSubmit = 'Submit',
      this.txtSubmitOnFace = 'Done',
      this.btnSubmit,
      this.btnSubmitOnFace})
      : super(key: key);

  final String ocrType;
  final String? ocrSubType;
  final Function onCapture;
  final bool? doFaceReg;
  final Function? onFaceReg;
  bool showRetakeBtn;
  Function? btnSubmit;
  Function? btnSubmitOnFace;
  String txtSubmit;
  String txtSubmitOnFace;

  @override
  State<MaskOCRCam> createState() => _MaskOCRCamState();
}

class _MaskOCRCamState extends State<MaskOCRCam> {
  @override
  Widget build(BuildContext context) {
    return widget.ocrType == 'idCard'
        ? widget.ocrSubType == 'greenIdCard'
            ? _buildShowResultList(widget.ocrSubType!)
            : _buildShowResultList(widget.ocrSubType!)
        : widget.ocrType == 'passport'
            ? _buildShowResultList(widget.ocrType)
            : Scaffold(
                appBar: AppBar(title: Text('OCR')),
                body: Container(
                  child: Text('Selected OCR Type = ${widget.ocrType}',
                      style: TextStyle(fontSize: 24)),
                ),
              );
  }

  Widget _buildShowResultList(String _ocrType) {
    return MaskForCameraView(
        ocrType: _ocrType,
        boxHeight: _ocrType == "whiteIdCard"
            ? 187.0
            : _ocrType == "greenIdCard"
                ? 178.0
                : 210,
        boxWidth: _ocrType == "whiteIdCard"
            ? 300.0
            : _ocrType == "greenIdCard"
                ? 300.0
                : 300,
        visiblePopButton: false,
        insideLine: MaskForCameraViewInsideLine(
          position: MaskForCameraViewInsideLinePosition.endPartThree,
          direction: MaskForCameraViewInsideLineDirection.horizontal,
        ),
        boxBorderWidth: 2.6,
        cameraDescription: MaskForCameraViewCameraDescription.rear,
        onTake: (MaskForCameraViewResult res) => (_ocrType == "whiteIdCard"
                ? imageToText([
                    res.secondPartImage,
                    res.thirdPartImage,
                    res.fourPartImage,
                    // res.fivePartImage
                  ])
                : _ocrType == "greenIdCard"
                    ? imageToText([
                        // res.croppedImage
                        res.firstPartImage,
                        res.secondPartImage,
                        res.thirdPartImage,
                        // res.fourPartImage,
                        // res.fivePartImage
                      ])
                    : imageToText([
                        res.croppedImage,
                        res.firstPartImage,
                        res.secondPartImage,
                        // res.thirdPartImage,
                        // res.fourPartImage,
                        // res.fivePartImage
                      ]))
            .then((value) => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                    return Container(
                      margin: EdgeInsets.only(top: 80),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 14.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26.0),
                          topRight: Radius.circular(26.0),
                        ),
                      ),
                      child: Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              },
                              icon: Icon(Icons.close)),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          centerTitle: true,
                          title: Text(
                            "OCR Results",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 12.0),
                                Row(
                                  children: [
                                    res.sixPartImage != null
                                        ? Container(
                                            height: 100,
                                            width: 80,
                                            child: MyImageView(
                                                imageBytes: res.sixPartImage!))
                                        : Container(),
                                    const SizedBox(width: 8.0),
                                    res.croppedImage != null
                                        ? Expanded(
                                            child: MyImageView(
                                                imageBytes: res.croppedImage!))
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                // Row(
                                //   children: [
                                //     res.firstPartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.firstPartImage!))
                                //         : Container(),
                                //     res.firstPartImage != null &&
                                //             res.secondPartImage != null
                                //         ? const SizedBox(width: 8.0)
                                //         : Container(),
                                //     res.secondPartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.secondPartImage!))
                                //         : Container(),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     res.thirdPartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.thirdPartImage!))
                                //         : Container(),
                                //     res.thirdPartImage != null &&
                                //             res.fourPartImage != null
                                //         ? const SizedBox(width: 8.0)
                                //         : Container(),
                                //     res.fourPartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.fourPartImage!))
                                //         : Container(),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     res.fivePartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.fivePartImage!))
                                //         : Container(),
                                //     res.fivePartImage != null &&
                                //             res.sixPartImage != null
                                //         ? const SizedBox(width: 8.0)
                                //         : Container(),
                                //     res.sixPartImage != null
                                //         ? Expanded(
                                //             child: MyImageView(
                                //                 imageBytes: res.sixPartImage!))
                                //         : Container(),
                                //   ],
                                // ),

                                listResult.isNotEmpty
                                    ? _buildListResult(res.croppedImage!)
                                    : Container(),
                                // const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                        bottomSheet: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                if (widget.showRetakeBtn)
                                  Expanded(
                                    child: Container(
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            _onRetakeCount++;
                                            // print(
                                            //     'on press retake = $_onRetakeCount');
                                            Navigator.pop(context);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: const Center(
                                            child: Text(
                                              "Retake",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.doFaceReg == true) ...[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            _btnNextProcess(
                                                imageBytes: res.sixPartImage!);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: const Center(
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            ),
                            if (widget.btnSubmit != null) ...[
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    onPressed: () {
                                      widget.btnSubmit!();
                                    },
                                    child: Text(widget.txtSubmit)),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  }),
                )));
  }

  List _ListDataValue() {
    RegExp expDate1 =
        new RegExp('^(?:0[0-9]|[12][0-9]|3[01])/(?:0[0-9]|1[01|02])/\\d{4}\$');
    RegExp expDate2 =
        new RegExp('^(?:0[0-9]|[12][0-9]|3[01]) [A-Z]{3} \\d{4}\$');
    TextInputType keyboardInputTypeText = TextInputType.text;
    TextInputType keyboardInputTypeDate = TextInputType.datetime;
    if (widget.ocrType == "idCard" && widget.ocrSubType == "greenIdCard")
      return [
        {
          "title": "Personal No.",
          "format": new RegExp('\\d{3} \\d{4} \\d{4} \\d{4}'),
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Document No.",
          "format": new RegExp('\\d{2}-\\d{2} \\d{6}'),
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Date of Birth",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
        {
          "title": "Issued Date",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
        {
          "title": "Expired Date",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
      ];
    else if (widget.ocrType == "idCard" && widget.ocrSubType == "whiteIdCard")
      return [
        {
          "title": "Document No.",
          "format": new RegExp('\\d{2}-[0-9]{7}'),
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Date of Birth",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
        {
          "title": "Issued Date",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
        {
          "title": "Expired Date",
          "format": expDate1,
          "inputType": keyboardInputTypeDate
        },
      ];
    else
      return [
        {
          "title": "Document No.",
          "format": new RegExp('[A-Z]{2} \\d{7}'),
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Issued Date",
          "format": expDate2,
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Expired Date",
          "format": expDate2,
          "inputType": keyboardInputTypeText
        },
        {
          "title": "Date of Birth",
          "format": expDate2,
          "inputType": keyboardInputTypeText
        },
      ];
  }

  int _onRetakeCount = 0;
  List _checkFormatValList = [];
  _buildListResult(Uint8List kycImg) {
    // print('lisssssss = $listResult');
    _checkFormatValList = [];
    if (listResult.isNotEmpty) {
      if (listResult.length < _ListDataValue().length) {
        var difVal = _ListDataValue().length - listResult.length;
        for (int i = 0; i < difVal; i++) {
          listResult.add("");
        }
      }

      final List tempData = [];
      for (int i = 0; i < _ListDataValue().length; i++) {
        final Map tempp = {
          "title": _ListDataValue()[i]['title'].toString(),
          'value': listResult[i]
        };
        tempData.add(tempp);
      }

      widget.onCapture(tempData, kycImg);

      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          itemCount: _ListDataValue().length,
          itemBuilder: (context, index) {
            if ((_ListDataValue()[index]['format'] as RegExp)
                .hasMatch(listResult[index]))
              _checkFormatValList.add(true);
            else
              _checkFormatValList.add(false);

            return Card(
              child: ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          _ListDataValue()[index]['title'].toString(),
                        ),
                      ),
                      Text(
                        '${listResult[index]}',
                        style: TextStyle(
                            color: (_ListDataValue()[index]['format'] as RegExp)
                                    .hasMatch(listResult[index])
                                ? Colors.green
                                : Colors.red),
                      ),
                    ]),
                trailing: _onRetakeCount >= 3
                    ? (_ListDataValue()[index]['format'] as RegExp)
                            .hasMatch(listResult[index])
                        ? null
                        : IconButton(
                            onPressed: () => _onEditDocData(
                                  index: index,
                                  editText: listResult[index],
                                  inputKeyboardType: _ListDataValue()[index]
                                      ['inputType'],
                                ),
                            icon: Icon(Icons.edit_note))
                    : null,
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _btnNextProcess({required Uint8List imageBytes}) {
    // print(_checkFormatValList.toList());
    // print('all ok = ${_checkFormatValList.every((el) => el == true)}');
    if (_checkFormatValList.every((el) => el == true)) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LivenessFace(
                    idCardProfileImg: imageBytes,
                    doFaceReg: widget.doFaceReg,
                    onFaceReg: (data) {
                      widget.onFaceReg!(data);
                    },
                    btnSubmit: widget.btnSubmitOnFace,
                    txtSubmit: widget.txtSubmitOnFace!,
                  )),
          (route) => true);
    } else {
      // print('Please correct data');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                alignment: Alignment.center,
                icon: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 56,
                ),
                title: Text("Error!"),
                content: Text("Please correct the data!",
                    textAlign: TextAlign.center),
              ));
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _txtInput = TextEditingController();
  void _onEditDocData(
      {required int index,
      required String editText,
      required TextInputType inputKeyboardType}) {
    _txtInput.text = editText;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 0.0),
              content: SizedBox(
                height: 270.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Icon(
                        Icons.edit_note_outlined,
                        size: 68,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Text(
                              "Edit",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Edit ${_ListDataValue()[index]['title']}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _txtInput,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        new RegExp("[0-9A-Z-/ ]")),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                      label: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text(
                                                  "${_ListDataValue()[index]['title']}",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.red))),
                                  textAlign: TextAlign.center,
                                  keyboardType: inputKeyboardType,
                                  maxLength: 18,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter value";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            if (_ListDataValue()[index]['title'] ==
                                "Issued Date") {
                              listResult[index] = _txtInput.text;
                              if (listResult[index + 1].toString().isEmpty) {
                                String tyear4d = listResult[index]
                                    .toString()
                                    .substring(
                                        listResult[index].toString().length -
                                            4);
                                if (new RegExp("\\d{4}").hasMatch(tyear4d)) {
                                  int tyear = int.parse(tyear4d);
                                  String tDate = listResult[index]
                                      .toString()
                                      .replaceAll("$tyear",
                                          "${widget.ocrType == "idCard" ? tyear + 5 : tyear + 10}");
                                  listResult[index + 1] = tDate;
                                }
                              }
                            } else {
                              listResult[index] = _txtInput.text;
                            }
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: const BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFcc0000),
                                Color(0xFF660000),
                              ],
                            )),
                        child: Text(
                          "Process",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  late String result;
  List listResult = [];
  String passportAllTextExtract = '';
  Future imageToText(List inputImgs) async {
    listResult = [];
    if (widget.ocrType == 'idCard') {
      // listResult = [];
      if (widget.ocrSubType == 'greenIdCard') {
        if (inputImgs.isNotEmpty)
          for (int i = 0; i < inputImgs.length; i++) {
            // print(inputImg);
            Uint8List imageInUnit8List = inputImgs[i];
            final tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/image$i.png').create();
            file.writeAsBytesSync(imageInUnit8List);
            // print('image path');
            // print(file.path);

            final inputImage = InputImage.fromFilePath(file.path);

            result = '';

            final textDetector = GoogleMlKit.vision.textRecognizer();
            final RecognizedText recognisedText =
                await textDetector.processImage(inputImage);

            setState(() {
              String text = recognisedText.text;
              for (TextBlock block in recognisedText.blocks) {
                //each block of text/section of text
                final String text = block.text;
                // print("block of text $i: ");
                // print(text);
                // for (TextLine line in block.lines) {
                //   //each line within a text block
                //   for (TextElement element in line.elements) {
                //     //each word within a line
                //     result += element.text + " ";
                //   }
                // }

                // if (text.contains(new RegExp('[0-9]'))) {
                //   if (text.contains('-')) {
                //     result = text.split('-').first.split(' ').last +
                //         '-' +
                //         text.split('-').last;
                //     print(result);
                //     if (result.length >= 10 &&
                //         (result.contains('-') || result.contains('/'))) {
                //       if (result.contains('o')) {
                //         result = result.replaceAll(RegExp(r'o'), '0');
                //       } else if (result.contains('O')) {
                //         result = result.replaceAll(RegExp(r'O'), '0');
                //       }
                //     }
                //     listResult.add(result);
                //   } else if (text.contains('/')) {
                //     // result = text.split(' ').last;
                //     result =
                //         text.split(' ').where((ele) => ele.contains('/')).last;
                //     print(result);
                //     if (result.length >= 10 &&
                //         (result.contains('-') || result.contains('/'))) {
                //       if (result.contains('o')) {
                //         result = result.replaceAll(RegExp(r'o'), '0');
                //       } else if (result.contains('O')) {
                //         result = result.replaceAll(RegExp(r'O'), '0');
                //       }
                //     }
                //     listResult.add(result);
                //   } else {
                //     result = text;
                //     print(result);
                //     // if (result.length >= 10 &&
                //     //     (result.contains('-') || result.contains('/')))
                //     if (result.length >= 15) {
                //       if (result.contains('o')) {
                //         result = result.replaceAll(RegExp(r'o'), '0');
                //       } else if (result.contains('O')) {
                //         result = result.replaceAll(RegExp(r'O'), '0');
                //       }
                //     }
                //     listResult.add(result);
                //   }
                // }

                result = text;
                if (text.contains(new RegExp('[0-9]'))) {
                  if (result.contains('o')) {
                    result = result.replaceAll(RegExp(r'o'), '0');
                  } else if (result.contains('O')) {
                    result = result.replaceAll(RegExp(r'O'), '0');
                  }
                  if (i == 0) {
                    RegExp exp = new RegExp('\\d{3} \\d{4} \\d{4} \\d{4}');
                    final match = exp.firstMatch(result);
                    if (match?.group(0) != null) {
                      // print("match data extract $i = ${match?.group(0)}");
                      listResult.add(match?.group(0));
                    }
                  } else if (i == 1) {
                    RegExp exp = new RegExp('\\d{2}-\\d{2} \\d{6}');
                    final match = exp.firstMatch(result);
                    if (match?.group(0) != null) {
                      // print("match data extract $i = ${match?.group(0)}");
                      listResult.add(match?.group(0));
                    }
                  } else {
                    if (text.contains('/')) {
                      if (result.contains('\n')) {
                        result = text
                            .split(' ')
                            .where((ele) => ele.contains('/'))
                            .first;
                      } else {
                        result = text
                            .split(' ')
                            .where((ele) => ele.contains('/'))
                            .last;
                      }

                      // print('ok res = ${result}');
                      RegExp exp = new RegExp('\\d{2}/\\d{2}/\\d{4}');
                      final match = exp.firstMatch(result);
                      if (match?.group(0) != null) {
                        // print(
                        //     "match data extract derr $i = ${match?.group(0)}");
                        listResult.add(match?.group(0));
                      }
                      // listResult.add(result);
                    }
                  }
                }
              }
              // result += "\n\n";
            });
            // print('result = ${result}');
            // print('result = ${result}');
            // setState(() {
            //   listResult.add(result);
            // });
          }
        if (listResult.length == 4) {
          String tempList = listResult.last;
          // print('last index = $tempList');
          if (tempList.contains('/')) {
            // print(tempList);
            // print(tempList.split('/').last);
            final tempRe = tempList.replaceAll(tempList.split('/').last,
                '${int.parse(tempList.split('/').last) + 5}');
            // print(tempRe);         print("match data extract = ${match?.group(0)}");
            //                   listResult.add(match?.group(0));
            listResult.add(tempRe);
          }
        }
        // print('list result = $listResult');
      } else {
        if (inputImgs.isNotEmpty)
          for (int i = 0; i < inputImgs.length; i++) {
            // print(inputImg);
            Uint8List imageInUnit8List = inputImgs[i];
            final tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/image$i.png').create();
            file.writeAsBytesSync(imageInUnit8List);
            // print('image path');
            // print(file.path);

            final inputImage = InputImage.fromFilePath(file.path);

            result = '';

            final textDetector = GoogleMlKit.vision.textRecognizer();
            final RecognizedText recognisedText =
                await textDetector.processImage(inputImage);

            setState(() {
              String text = recognisedText.text;
              for (TextBlock block in recognisedText.blocks) {
                //each block of text/section of text
                final String text = block.text;
                // print("block of text $i: ");
                // print(text);
                // for (TextLine line in block.lines) {
                //   //each line within a text block
                //   for (TextElement element in line.elements) {
                //     //each word within a line
                //     result += element.text + " ";
                //   }
                // }

                if (text.contains(new RegExp('[0-9]'))) {
                  if (text.contains('-')) {
                    result = text.split('-').first.split(' ').last +
                        '-' +
                        text.split('-').last;
                    // print(result);
                    if (result.length >= 10 &&
                        (result.contains('-') || result.contains('/'))) {
                      if (result.contains('o')) {
                        result = result.replaceAll(RegExp(r'o'), '0');
                      } else if (result.contains('O')) {
                        result = result.replaceAll(RegExp(r'O'), '0');
                      }
                    }
                    listResult.add(result);
                  } else if (text.contains('/')) {
                    // result = text.split(' ').last;
                    result =
                        text.split(' ').where((ele) => ele.contains('/')).last;
                    // print(result);
                    if (result.length >= 10 &&
                        (result.contains('-') || result.contains('/'))) {
                      if (result.contains('o')) {
                        result = result.replaceAll(RegExp(r'o'), '0');
                      } else if (result.contains('O')) {
                        result = result.replaceAll(RegExp(r'O'), '0');
                      }
                    }

                    listResult.add(result);
                  }
                }

                // result = text;
                // if (text.contains(new RegExp('[0-9]'))) {
                //   if (result.contains('o')) {
                //     result = result.replaceAll(RegExp(r'o'), '0');
                //   } else if (result.contains('O')) {
                //     result = result.replaceAll(RegExp(r'O'), '0');
                //   }
                //   if (i == 0) {
                //     RegExp exp = new RegExp('\\d{2}-[0-9]{7}');
                //     final match = exp.firstMatch(result);
                //     if (match?.group(0) != null) {
                //       print("match data extract $i = ${match?.group(0)}");
                //       listResult.add(match?.group(0));
                //     }
                //   } else {
                //     RegExp exp = new RegExp('\\d{2}/[0-2]{2}/\\d{4}');
                //     final match = exp.firstMatch(result);
                //     final chk2 = RegExp('[0-2]{2}/\\d{6}').firstMatch(result);
                //     final chk3 = RegExp('\\d{4}/\\d{4}').firstMatch(result);
                //     if (match?.group(0) != null) {
                //       print("match data extract $i = ${match?.group(0)}");
                //       listResult.add(match?.group(0));
                //     } else if (chk2?.group(0) != null) {
                //       final tday = chk2?.group(0)?.split('/').first;
                //       final tmonth = chk2?.group(0)?.substring(3, 5);
                //       final tyear = chk2?.group(0)?.substring(5);
                //       final tDate = '$tday/$tmonth/$tyear';
                //       listResult.add(tDate);
                //     } else if (chk3?.group(0) != null) {
                //       final tday = chk3?.group(0)?.substring(0, 2);
                //       final tmonth = chk3?.group(0)?.substring(2, 4);
                //       final tyear = chk3?.group(0)?.split('/').last;
                //       final tDate = '$tday/$tmonth/$tyear';
                //       listResult.add(tDate);
                //     }
                //   }
                // }

              }
              // result += "\n\n";
            });
            // print('result = ${result}');
            // print('result = ${result}');
            // setState(() {
            //   listResult.add(result);
            // });
          }
        if (listResult.length == 3) {
          String tempList = listResult.last;
          // print('last index = $tempList');
          if (tempList.contains('/')) {
            // print(tempList);
            // print(tempList.split('/').last);
            final tempRe = tempList.replaceAll(tempList.split('/').last,
                '${int.parse(tempList.split('/').last) + 5}');
            // print(tempRe);         print("match data extract = ${match?.group(0)}");
            //                   listResult.add(match?.group(0));
            listResult.add(tempRe);
          }
        }
        // print('list result = $listResult');
      }
    } else {
      if (inputImgs.isNotEmpty)
        for (int i = 0; i < inputImgs.length; i++) {
          // print(inputImg);
          Uint8List imageInUnit8List = inputImgs[i];
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/image$i.png').create();
          file.writeAsBytesSync(imageInUnit8List);
          // print('image path');
          // print(file.path);

          final inputImage = InputImage.fromFilePath(file.path);

          result = '';

          final textDetector = GoogleMlKit.vision.textRecognizer();
          final RecognizedText recognisedText =
              await textDetector.processImage(inputImage);

          setState(() {
            String text = recognisedText.text;
            for (TextBlock block in recognisedText.blocks) {
              //each block of text/section of text
              final String text = block.text;
              // print("block of text $i: ");
              // print(text);
              if (i == 0)
                for (TextLine line in block.lines) {
                  //each line within a text block
                  for (TextElement element in line.elements) {
                    //each word within a line
                    // result += element.text + " ";
                    passportAllTextExtract += element.text + " ";
                  }
                }
              else if (i == 1) {
                if (text.contains(new RegExp('[0-9]'))) {
                  result = text;
                  // print("value = $result");

                  // if (result.contains(monthInPassPort.join(","))) {
                  //   print('data month22');
                  //   print(monthInPassPort.contains(result));
                  //   print(result);
                  //   // listResult.add(result);
                  // } else {
                  //   if (result.contains('o')) {
                  //     result = result.replaceAll(RegExp(r'o'), '0');
                  //   } else if (result.contains('O')) {
                  //     result = result.replaceAll(RegExp(r'O'), '0');
                  //   }
                  // if (i == 1)
                  listResult.add(result);
                  // else {
                  //   final tempAdd = result
                  //       .split('\n')
                  //       .where((e) => e.contains(new RegExp('[0-9]')))
                  //       .toList();
                  //   // .toString()
                  //   // .replaceAll(RegExp('[^A-Z0-9 ]'), '');
                  //   print('object = ');
                  //   print(tempAdd);
                  //
                  //   // RegExp exp = new RegExp('\\d{2}/\\d{2}/\\d{4}');
                  //   // RegExp exp = new RegExp('\\d{2} [A-Z]{3} \\d{4}');
                  //   // final match =
                  //   //     exp.firstMatch('data has date 20 SEP 2022 der der 30 MAY 2001');
                  //   // print("match data extract = ${match!.group(0)}");
                  //
                  //   listResult.addAll(tempAdd);
                  // }
                  // }
                }
              } else {
                result = text;
                RegExp exp = new RegExp('\\d{2} [A-Z]{3} \\d{4}');
                final match = exp.firstMatch(result);
                if (match?.group(0) != null) {
                  // print("match data extract = ${match?.group(0)}");
                  listResult.add(match?.group(0));
                }
              }
            }

            // result += "\n\n";
          });
        }
      if (listResult.length == 3) {
        String tempList = listResult[1];
        // print('last index = $tempList');
        if (tempList.contains(' ')) {
          // print(tempList);
          // print(tempList.split('/').last);
          final tempRe = tempList.replaceAll(tempList.split(' ').last,
              '${int.parse(tempList.split(' ').last) + 10}');
          // print(tempRe);
          listResult.insert(2, tempRe);
        }
      }
      // print('list result = $listResult');
      // print(
      //     'sum result = ${passportAllTextExtract.replaceAll(RegExp('[^A-Za-z0-9< ]'), '')}');
    }
  }
}

class MyImageView extends StatelessWidget {
  const MyImageView({Key? key, required this.imageBytes}) : super(key: key);
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: SizedBox(
        width: double.infinity,
        child: Image.memory(imageBytes),
      ),
    );
  }
}
