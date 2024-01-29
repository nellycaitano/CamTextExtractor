import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'camscreen.dart';
import 'photoscreen.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class MyhomePage extends StatefulWidget {
  const MyhomePage({Key? key}) : super(key: key);

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f4),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        margin: EdgeInsets.all(15),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CamText Extractor',
                  style: GoogleFonts.parisienne(
                    textStyle: TextStyle(fontSize: 23),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40.0),
                Text(
                  'Capturez instantanément le texte de vos images avec simplicité, offrant une expérience de lecture fluide et accessible.',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(fontSize: 14),
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 100),
                Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(
                      'images/ph--thin.svg',
                      semanticsLabel: 'scan',
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 25, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CamScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFfaece3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'images/solar-camera.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 100),
                  GestureDetector(
                    onTap: () {
                      _pickImageAndExtractText(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFfaece3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'images/gallery.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 2,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  
                },
                child: Container(
                  width: 25,
                  height: 25,
                  child: SvgPicture.asset(
                    'images/history.svg',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageAndExtractText(BuildContext context) async {
    final imagePicker = ImagePicker();
    final TextRecognizer _textRecognizer =
        GoogleMlKit.vision.textRecognizer();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
    
      return;
    }

    final File file = File(pickedImage.path);
    final inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoScreen(text: recognizedText.text),
      ),
    );
  }
}
