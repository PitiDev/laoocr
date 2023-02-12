import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

import 'inside_line.dart';
import 'inside_line_direction.dart';
import 'inside_line_position.dart';
import 'result.dart';

Future<MaskForCameraViewResult?> cropImage(
    String ocrType,
    String imagePath,
    int cropHeight,
    int cropWeight,
    double screenHeight,
    double screenWidth,
    MaskForCameraViewInsideLine? insideLine) async {
  Uint8List imageBytes = await File(imagePath).readAsBytes();

  Image? image = decodeImage(imageBytes);

  double? increasedTimesW;
  double? increasedTimesH;
  if (image!.width > screenWidth) {
    increasedTimesW = image.width / screenWidth;
    increasedTimesH = image.height / screenHeight;
  } else {
    return null;
  }

  double sX = (screenWidth - cropWeight) / 2;
  double sY = (screenHeight - cropHeight) / 2;

  double x = sX * increasedTimesW;
  double y = sY * increasedTimesH;

  double w = cropWeight * increasedTimesW;
  double h = cropHeight * increasedTimesH;

  Image croppedImage =
      copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
  MaskForCameraViewResult res = MaskForCameraViewResult();
  if (ocrType.isNotEmpty && insideLine != null) {
    MaskForCameraViewResult halfRes =
        await _cropHalfImage(ocrType, croppedImage, insideLine);
    res = halfRes;
  }
  List<int> croppedList = encodeJpg(croppedImage);
  Uint8List croppedBytes = Uint8List.fromList(croppedList);
  res.croppedImage = croppedBytes;
  return res;
}

Future<MaskForCameraViewResult> _cropHalfImage(
    String ocrType, Image image, MaskForCameraViewInsideLine insideLine) async {
  double x;
  double y;
  double w;
  double h;

  if (ocrType == 'greenIdCard') {
    //todo half first image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      // y = 270;
      // y = (image.height / 10) * _position(insideLine.position);
      y = image.height.toDouble() - (_position(insideLine.position) * 6);
      // print('y11 = $y');
      // print(_position(insideLine.position));
      // print('image.height = ${image.height}');
      x = 0;
      w = image.width.toDouble() - 310;
      h = 140;
      // h = image.height - y;
    } else {
      y = 0;
      x = 0;
      w = (image.width / 10) * _position(insideLine.position);
      h = image.height.toDouble();
    }
    Image firstCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());

    List<int> firstCroppedList = encodeJpg(firstCroppedImage);
    Uint8List firstCroppedBytes = Uint8List.fromList(firstCroppedList);

    //todo half second image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      // y = (image.height / 10) * _position(insideLine.position);
      y = 55;
      // print("data yy = $y");
      // x = 360;
      x = image.width.toDouble() - (_position(insideLine.position) * 28);
      // print("data xx = $x");
      // print(image.width);
      // w = image.width.toDouble() - 205;
      w = 180;
      h = 50;
      // h = image.height - 250;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image secondCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> secondCroppedList = encodeJpg(secondCroppedImage);
    Uint8List secondCroppedBytes = Uint8List.fromList(secondCroppedList);

    //todo half third image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      // y = image.height.toDouble() - (_position(insideLine.position) * 30);
      // // print('print y1 = $y');
      // // y = 115;
      // x = 300;
      // w = 120;
      // h = image.height - 260;

      // todo neww
      y = 120;
      x = 170;
      w = image.width.toDouble() - 270;
      h = image.height.toDouble() - 150;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image thirdCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> thirdCroppedList = encodeJpg(thirdCroppedImage);
    Uint8List thirdCroppedBytes = Uint8List.fromList(thirdCroppedList);

    //todo half four image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = image.height.toDouble() - (_position(insideLine.position) * 15);
      // y = 210;
      x = 260;
      w = 150;
      h = image.height - 269;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fourCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fourCroppedList = encodeJpg(fourCroppedImage);
    Uint8List fourCroppedBytes = Uint8List.fromList(fourCroppedList);

    //todo half five image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 232;
      x = 260;
      w = 100;
      h = 35;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fiveCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fiveCroppedList = encodeJpg(fiveCroppedImage);
    Uint8List fiveCroppedBytes = Uint8List.fromList(fiveCroppedList);

    //todo half six image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 90;
      x = 05;
      w = 185;
      h = 200;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image sixCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> sixCroppedList = encodeJpg(sixCroppedImage);
    Uint8List sixCroppedBytes = Uint8List.fromList(sixCroppedList);

    MaskForCameraViewResult res = MaskForCameraViewResult(
        firstPartImage: firstCroppedBytes,
        secondPartImage: secondCroppedBytes,
        thirdPartImage: thirdCroppedBytes,
        fourPartImage: fourCroppedBytes,
        // fivePartImage: fiveCroppedBytes,
        sixPartImage: sixCroppedBytes);

    return res;
  } else if (ocrType == 'whiteIdCard') {
    //todo half second image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 40;
      x = image.width - 160;
      w = 150;
      h = 50;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image secondCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> secondCroppedList = encodeJpg(secondCroppedImage);
    Uint8List secondCroppedBytes = Uint8List.fromList(secondCroppedList);

    //todo half third image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = image.height - 250;
      x = image.width - 340;
      w = 150;
      h = 70;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image thirdCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> thirdCroppedList = encodeJpg(thirdCroppedImage);
    Uint8List thirdCroppedBytes = Uint8List.fromList(thirdCroppedList);

    //todo half four image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = image.height - 125;
      // x = 190;
      x = image.width - 135;
      print('y = $y');
      print('x = $x');
      // w = image.width - 5;
      w = 150;
      // print('z = $w');
      h = 55;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fourCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fourCroppedList = encodeJpg(fourCroppedImage);
    Uint8List fourCroppedBytes = Uint8List.fromList(fourCroppedList);

    //todo half five image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = image.height - 90;
      x = image.width - 315;
      w = 150;
      h = 55;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fiveCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fiveCroppedList = encodeJpg(fiveCroppedImage);
    Uint8List fiveCroppedBytes = Uint8List.fromList(fiveCroppedList);

    //todo half six image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 90;
      x = 05;
      w = 140;
      h = 150;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image sixCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> sixCroppedList = encodeJpg(sixCroppedImage);
    Uint8List sixCroppedBytes = Uint8List.fromList(sixCroppedList);

    MaskForCameraViewResult res = MaskForCameraViewResult(
        secondPartImage: secondCroppedBytes,
        thirdPartImage: thirdCroppedBytes,
        fourPartImage: fourCroppedBytes,
        fivePartImage: fiveCroppedBytes,
        sixPartImage: sixCroppedBytes);

    return res;
  } else if (ocrType == 'passport') {
    //todo half first image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 45;
      x = 365;
      w = image.width.toDouble() - 215;
      h = 50;
    } else {
      y = 0;
      x = 0;
      w = (image.width / 10) * _position(insideLine.position);
      h = image.height.toDouble();
    }
    Image firstCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());

    List<int> firstCroppedList = encodeJpg(firstCroppedImage);
    Uint8List firstCroppedBytes = Uint8List.fromList(firstCroppedList);

    //todo half second image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      // y = 145;
      // x = 350;
      // w = 100;
      // h = 32;
      y = 150;
      x = 170;
      w = image.width - 20;
      h = image.height - 250;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image secondCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> secondCroppedList = encodeJpg(secondCroppedImage);
    Uint8List secondCroppedBytes = Uint8List.fromList(secondCroppedList);

    //todo half third image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 200;
      x = 180;
      w = 100;
      h = 32;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image thirdCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> thirdCroppedList = encodeJpg(thirdCroppedImage);
    Uint8List thirdCroppedBytes = Uint8List.fromList(thirdCroppedList);

    //todo half four image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 230;
      x = 185;
      w = 100;
      h = 32;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fourCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fourCroppedList = encodeJpg(fourCroppedImage);
    Uint8List fourCroppedBytes = Uint8List.fromList(fourCroppedList);

    //todo half five image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      // y = 400;
      y = (image.height / 10) * _position(insideLine.position);
      x = 05;
      w = image.width.toDouble() - x;
      // w = image.width - x;
      h = image.height - 250;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image fiveCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> fiveCroppedList = encodeJpg(fiveCroppedImage);
    Uint8List fiveCroppedBytes = Uint8List.fromList(fiveCroppedList);

    //todo half six image
    if (insideLine.direction == null ||
        insideLine.direction ==
            MaskForCameraViewInsideLineDirection.horizontal) {
      y = 75;
      x = 05;
      w = 160;
      h = 200;
    } else {
      y = 0;
      x = (image.width / 10) * _position(insideLine.position);
      w = image.width - x;
      h = image.height.toDouble();
    }
    Image sixCroppedImage =
        copyCrop(image, x:x.toInt(), y:y.toInt(), width:w.toInt(), height:h.toInt());
    List<int> sixCroppedList = encodeJpg(sixCroppedImage);
    Uint8List sixCroppedBytes = Uint8List.fromList(sixCroppedList);

    MaskForCameraViewResult res = MaskForCameraViewResult(
        firstPartImage: firstCroppedBytes,
        secondPartImage: secondCroppedBytes,
        // thirdPartImage: thirdCroppedBytes,
        // fourPartImage: fourCroppedBytes,
        // fivePartImage: fiveCroppedBytes,
        sixPartImage: sixCroppedBytes);

    return res;
  } else {
    MaskForCameraViewResult res = MaskForCameraViewResult(
      firstPartImage: image.getBytes(),
    );
    return res;
  }
}

int _position(MaskForCameraViewInsideLinePosition? position) {
  int p = 5;
  if (position != null) {
    p = position.index + 1;
  }
  return p;
}
