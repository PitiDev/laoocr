import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_face_api/face_api.dart' as Regula;

class LivenessFace extends StatefulWidget {
  LivenessFace(
      {Key? key,
      required this.idCardProfileImg,
      this.doFaceReg,
      this.onFaceReg,
      this.txtSubmit = 'Done',
      this.btnSubmit})
      : super(key: key);

  final Uint8List idCardProfileImg;
  final bool? doFaceReg;
  final Function? onFaceReg;
  Function? btnSubmit;
  String txtSubmit;

  @override
  State<LivenessFace> createState() => _LivenessFaceState();
}

class _LivenessFaceState extends State<LivenessFace> {
  // static const String asstImg = 'assets/images/portrait.png';
  static const String asstImg =
      'https://github.com/Tonhbcl28/laoocr/blob/3e415a3cec15a97595fa3957280f72a3e2a409d7/assets/images/portrait.png?raw=true';
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  // var img1 = Image.asset(asstImg);
  var img1 = Image.network(asstImg);
  var img2;
  String _similarity = "0";
  String _liveness = "0";

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    setState(() {
      img2 = Image.memory(widget.idCardProfileImg);
      image2.bitmap = base64Encode(widget.idCardProfileImg);
      image2.imageType = Regula.ImageType.LIVE;
    });
    liveness();
  }

  setImage(bool first, Uint8List? imageFile, int type) {
    try {
      if (imageFile!.isEmpty) {
        clearResults();
      } else {
        if (first) {
          image1.bitmap = base64Encode(imageFile);
          image1.imageType = type;
          setState(() {
            img1 = Image.memory(imageFile);
            // _liveness = "0";
          });
        } else {
          image2.bitmap = base64Encode(imageFile);
          image2.imageType = type;
          setState(() => img2 = Image.memory(imageFile));
        }
      }
    } catch (e) {
      clearResults();
    }
  }

  clearResults() {
    setState(() {
      // img1 = Image.asset(asstImg);
      img1 = Image.network(asstImg);
      img2 = Image.memory(widget.idCardProfileImg);
      _similarity = "0";
      _liveness = "0";
    });
    image1 = new Regula.MatchFacesImage();
    // image2 = new Regula.MatchFacesImage();
    // image2.bitmap = base64Encode(widget.idCardProfileImg);
  }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => _similarity = "loading...");
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        setState(() => _similarity = split!.matchedFaces.length > 0
            ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
                "%")
            : "0");

        Map tempData = {
          'liveliness': _liveness,
          'similarity': _similarity,
          'liveImg': image1.bitmap
        };
        if (widget.doFaceReg == true) {
          if (widget.onFaceReg != null) {
            widget.onFaceReg!(tempData);
          }
        }
      });
    }).whenComplete(() {});
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
        var result = Regula.LivenessResponse.fromJson(json.decode(value));
        setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),
            Regula.ImageType.LIVE);
        setState(() => _liveness = result.liveness == 0 ? "Passed" : "Fail");
      }).whenComplete(() => matchFaces());

  Widget createButton(String text, VoidCallback onPress,
          [Color? color, double? width]) =>
      Container(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        height: 50,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: onPress,
            child: Text(text)),
      );

  Widget createImage(image, Color color) => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: color, width: 4)),
        child: ClipOval(
            child: Image(
          height: 120,
          width: 120,
          image: image,
          fit: BoxFit.cover,
        )),
      );

  Widget buildResults(title, result, Color color) => Card(
        child: Text.rich(
            TextSpan(text: title, style: TextStyle(fontSize: 32), children: [
          TextSpan(
              text: " $result",
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                backgroundColor: color,
              ))
        ])),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          centerTitle: true,
          title: Text(
            "Liveness Verification",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createImage(img1.image, Colors.red),
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Column(
                        children: [
                          Icon(
                            Icons.enhance_photo_translate_outlined,
                            color: _liveness == "Passed"
                                ? Colors.green
                                : Colors.red,
                          ),
                          Container(
                            height: 30,
                            width: 5,
                            color: _liveness == "Passed" &&
                                    _similarity.contains(RegExp("[0-9]")) &&
                                    double.parse(_similarity.split("%")[0]) >=
                                        80
                                ? Colors.green
                                : Colors.red,
                          ),
                          Icon(
                            Icons.verified_outlined,
                            color: _liveness == "Passed" &&
                                    _similarity.contains(RegExp("[0-9]")) &&
                                    double.parse(_similarity.split("%")[0]) >=
                                        80
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                    createImage(img2.image, Colors.blue),
                  ]),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    shadowColor: _liveness == "Passed" &&
                            _similarity.contains(RegExp("[0-9]")) &&
                            double.parse(_similarity.split("%")[0]) >= 80
                        ? Colors.green
                        : Colors.red,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Results",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                  decoration: TextDecoration.underline)),
                          buildResults(
                              "Liveness : ",
                              _liveness,
                              _liveness == "Passed"
                                  ? Colors.green
                                  : Colors.red),
                          Container(margin: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                          buildResults(
                              "Similarity: ",
                              _similarity,
                              _similarity.contains(RegExp("[0-9]"))
                                  ? double.parse(_similarity.split("%")[0]) >=
                                          80
                                      ? Colors.blue
                                      : Colors.red
                                  : Colors.deepOrange),
                        ],
                      ),
                    ),
                  )),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
              Row(children: [
                Expanded(
                    child: createButton(
                        "Reset", () => clearResults(), Colors.red)),
                Expanded(
                    child: createButton(
                        "Selfie Again", () => liveness(), Colors.blue)),
              ]),
              // createButton("Match", () => matchFaces()),
            ])),
        bottomSheet: widget.btnSubmit != null
            ? createButton(widget.txtSubmit, () {
                widget.btnSubmit!();
              }, null, double.infinity)
            : null,
      );
}
