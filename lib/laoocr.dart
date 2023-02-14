library laoocr;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'lao_ocr/main_crop.dart';
import 'lao_ocr/mask_camera.dart';

class LaoOCRScan extends StatefulWidget {
  LaoOCRScan(
      {Key? key,
      this.title = 'Lao OCR',
      this.subTitle = 'Select LAO OCR Type',
      required this.onCapture,
      this.doFaceReg = false,
      this.onFaceReg,
      this.showRetakeBtn = true,
      this.txtSubmit = 'Submit',
      this.txtSubmitOnFace = 'Done',
      this.btnSubmit,
      this.btnSubmitOnFace,
      this.showSubmitBtn = false,
      this.showFaceSubmitBtn = false,
      this.showPopBack = false})
      : super(key: key);

  String title;
  String subTitle;
  final Function onCapture;
  bool doFaceReg;
  final Function? onFaceReg;
  bool showRetakeBtn;
  Function? btnSubmit;
  Function? btnSubmitOnFace;
  String txtSubmit;
  String txtSubmitOnFace;
  bool showSubmitBtn;
  bool showFaceSubmitBtn;
  bool showPopBack;

  @override
  State<LaoOCRScan> createState() => _LaoOCRScanState();
}

class _LaoOCRScanState extends State<LaoOCRScan> {
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();
    initPlatform();
    super.initState();
  }

  Future<void> initPlatform() async {
    await MaskForCameraView.initialize();
  }

  //ocr type
  List<Map<String, Object>> _rdoOcrType = [
    {'id': 'idCard', 'name': 'ID Card'},
    {'id': 'passport', 'name': 'Passport'},
    // {'id': 'familyBook', 'name': 'Family Book'},
  ];
  int? _rdoStartindex;
  String _onSelectRdo = '';

  //sub ocr type
  List<Map<String, Object>> _rdoOcrSubType = [
    {'id': 'whiteIdCard', 'name': 'White ID Card'},
    {'id': 'greenIdCard', 'name': 'Green ID Card'},
  ];
  int? _rdoSubStartindex;
  String _onSelectSubRdo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.subTitle,
              style: const TextStyle(fontSize: 24),
            ),
            for (int i = 0; i < _rdoOcrType.length; i++)
              RadioListTile(
                  title: Text(_rdoOcrType[i]['name'].toString()),
                  value: i,
                  groupValue: _rdoStartindex,
                  onChanged: (int? value) {
                    setState(() {
                      _rdoStartindex = value;
                      _onSelectRdo = _rdoOcrType[i]['id'].toString();
                    });
                    // print(_onSelectRdo);
                  }),
            const Divider(),
            _rdoStartindex != null && _rdoStartindex == 0
                ? Column(children: [
                    for (int i = 0; i < _rdoOcrSubType.length; i++)
                      RadioListTile(
                          title: Text(_rdoOcrSubType[i]['name'].toString()),
                          value: i,
                          groupValue: _rdoSubStartindex,
                          onChanged: (int? value) {
                            setState(() {
                              _rdoSubStartindex = value;
                              _onSelectSubRdo =
                                  _rdoOcrSubType[i]['id'].toString();
                            });
                            // print(_onSelectSubRdo);
                          }),
                  ])
                : Container(),
            Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: _onSubmit,
                  icon: const Icon(Icons.navigate_next_outlined),
                  label: Text(widget.txtSubmit)),
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit() {
    if (_onSelectRdo.isNotEmpty) if (_rdoStartindex == 0) if (_onSelectSubRdo
        .isNotEmpty)
      _navigatePage(_onSelectRdo, _onSelectSubRdo);
    else
      _alertBox('Error!', 'No selected SUB OCR option!');
    else
      _navigatePage(_onSelectRdo);
    else
      _alertBox('Error!', 'No selected OCR option!');
  }

  _navigatePage(_ocrType, [String? _ocrSubType]) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MaskOCRCam(
                  ocrType: _ocrType,
                  ocrSubType: _ocrSubType,
                  showPopBack: widget.showPopBack,
                  onCapture: (val, img) {
                    final Map data = {
                      'kycType': _ocrType == 'idCard' ? _ocrSubType : _ocrType,
                      'data': val,
                      'kycImg': img
                    };
                    widget.onCapture(data);
                  },
                  doFaceReg: widget.doFaceReg,
                  onFaceReg: widget.doFaceReg == true
                      ? (data) {
                          if (widget.onFaceReg != null)
                            widget.onFaceReg!(data);
                          else
                            null;
                        }
                      : null,
                  btnSubmitOnFace: widget.showFaceSubmitBtn
                      ? () {
                          if (widget.btnSubmitOnFace != null)
                            widget.btnSubmitOnFace!();
                        }
                      : null,
                  txtSubmitOnFace: widget.txtSubmitOnFace,
                  showRetakeBtn: widget.showRetakeBtn,
                  txtSubmit: widget.txtSubmit,
                  btnSubmit: widget.showSubmitBtn
                      ? () {
                          if (widget.btnSubmit != null) widget.btnSubmit!();
                        }
                      : null,
                )),
        (route) => true);
  }

  _alertBox(title, msg) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close))
              ],
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 54,
                    color: Colors.red,
                  ),
                  Text('$title'),
                ],
              ),
              content: Text('$msg', textAlign: TextAlign.center),
            ));
  }
}
