import 'dart:typed_data';

class MaskForCameraViewResult {
  MaskForCameraViewResult(
      {this.croppedImage,
      this.firstPartImage,
      this.secondPartImage,
      this.thirdPartImage,
      this.fourPartImage,
      this.fivePartImage,
      this.sixPartImage});
  Uint8List? croppedImage;
  Uint8List? firstPartImage;
  Uint8List? secondPartImage;
  Uint8List? thirdPartImage;
  Uint8List? fourPartImage;
  Uint8List? fivePartImage;
  Uint8List? sixPartImage;
}
