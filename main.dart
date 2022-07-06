// Coded by AlfaWhoCodes

// Follow on Instagram : https://www.instagram.com/alfawhocodes/
/*  
----------------------------------------------

Hi, i’m a Mobile App Developer
8+ Years of coding experience
Mentored 100+ students on App development
Join our Community @codewithpurplegang 

----------------------------------------------
*/

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:alfawhocodes/confitte.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Confetti(),
  ));
}

class QRPage extends StatefulWidget {
  @override
  State<QRPage> createState() => _QRPageState();

  ScreenshotController screenshotController = ScreenshotController();
}

class _QRPageState extends State<QRPage> {
  final backkey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController _qrTextController = TextEditingController();
  bool permissionGranted = false;
  Color _PrimaryCurrentColor = Colors.black;
  String _primaryTextColorText = '';
  bool isQRvalid = false;
  @override
  void initState() {
    super.initState();
    _getStoragePermission();
    // _requestPermission();
  }

  void changePrimaryColor(Color color) {
    setState(() => {
          _PrimaryCurrentColor = color,
          _primaryTextColorText = _PrimaryCurrentColor.toString(),
          _PrimaryCurrentColor = new Color(int.parse(
              _primaryTextColorText.split('(0x')[1].split(')')[0],
              radix: 16)),
          // _selectedBackgroundImg = '',
          // _SelectedValue = CardBackground(imgId: 999, imgpath: '')
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                // margin:

                //     EdgeInsets.only(left: 56, right: 56, top: 12, bottom: 12),
                child: RepaintBoundary(
                  key: backkey,
                  child: QrImage(
                    data: _qrTextController.text,
                    version: QrVersions.auto,
                    backgroundColor: Colors.transparent,
                    foregroundColor: _PrimaryCurrentColor,
                    gapless: false,
                    size: 180,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                  child: Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200),
              )),
              SizedBox(
                height: 16,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 36, right: 36, top: 12, bottom: 12),
                child: TextField(
                  cursorColor: Colors.black45,
                  style: TextStyle(fontSize: 14),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  // ],
                  controller: _qrTextController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelStyle: TextStyle(color: Colors.black),
                    labelText: 'Enter URL',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    focusColor: Colors.black45,
                    border: InputBorder.none,
                    //  hintText: 'Email ID',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (_qrTextController.text.isEmpty) {
                        isQRvalid = false;
                      } else {
                        isQRvalid = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 260,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onSurface: Colors.black54,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: isQRvalid
                      ? () async {
                          setState(() {});

                          DateTime _now = DateTime.now();
                          String cardIDtext =
                              'CID${_now.year}${_now.month}${_now.day}${_now.hour}${_now.minute}${_now.second}${_now.millisecond}${_now.microsecond}';
                          await _captureBack();

                          final snackBar = SnackBar(
                            backgroundColor: Colors.black,
                            content: const Text(
                              'QR Code Saved to Gallery ',
                              style: TextStyle(color: Colors.white),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      : null,
                  child: const Text(
                    'Save QR Code',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'QR Code Generator',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                  Text(
                    ' by AlfaWhoCodes',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              )),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialPicker(
                    // enableLabel: true,
                    portraitOnly: true,
                    pickerColor: _PrimaryCurrentColor,
                    onColorChanged: changePrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  Future<String> _captureBack() async {
    final boundary =
        backkey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);

    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final backimageBytes = byteData?.buffer.asUint8List();

    if (backimageBytes != null) {
      await ImageGallerySaver.saveImage(backimageBytes.buffer.asUint8List());
    }

    // print(imageBytes);
    var bs64 = base64Encode(backimageBytes!);

    return bs64;
  }
}
