# Lao OCR Scan (Lao KYC Scanner)

<a href="https://www.buymeacoffee.com/phoutthako7" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

The First Lao OCR and Face Liveliness. Which you can scan Lao ID card(White ID card and Green ID Card), Passport.
The package can extract necessary data.
And you also take liveliness and match image from kyc document to compare that is the right person using the document or not.

- This this the first version which can work with Lao ID and passport only, If you want me to develop more for Lao family book please support me! and let me know.
- you can contact me at *phoutthakonebcl@gmail.com

## Preview
![](assets/images/laoocr.gif)

## Features
Package can extract the data from document as the following:
- Document Number.
- Date of birth.
- Issued Date.
- Expired Date, etc.
- Can match image from kyc document and liveliness cam to compare that is right person or not.

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started
Install the package and call the widget directly you will receive the result.
### install with flutter
```
flutter pub add laoocr
flutter pub get
```
### Then You have to import the package to your project
```
import 'package:laoocr/laoocr.dart';
```

## General Setup
- Requirement SDK minimum version 2.18 up.
### Android
Nothing to config

### IOS
You must add camera permission to the info.plist file.

## Usage
You can call the widget and get the response after the KYC Scan.
Please find the example Code:
```
LaoOCRScan(
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
    )
```

## Additional information
This Package can help Lao developer to work with KYC document and it's very easy to use with the high performance.
It can save the company cost too much.
- This this the first version which can work with Lao ID and passport only, If you want me to develop more for Lao family book please support me! and let me know.
- you can contact me at *phoutthakonebcl@gmail.com
  Thank you so much 😘 (❁´◡`❁).
