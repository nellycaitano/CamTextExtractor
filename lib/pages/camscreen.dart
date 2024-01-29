import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'photoscreen.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}



class _CamScreenState extends State<CamScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return _isPermissionGranted
            ? _buildCameraPreview()
            : _buildPermissionDenied();
      },
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        FutureBuilder<List<CameraDescription>>(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _initCameraController(snapshot.data!);
              return Center(child: CameraPreview(_cameraController!));
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
        Scaffold(
          backgroundColor: _isPermissionGranted ? Colors.transparent : null,
          body: _isPermissionGranted
              ? Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              _scanImage();
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
                      ),),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      'Camera permission denied',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(
            'Camera permission denied',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> _initCameraController(List<CameraDescription> cameras) async {
    if (_cameraController == null) {
      final camera = cameras.isNotEmpty ? cameras.first : null;
      if (camera != null) {
        _cameraSelected(camera);
      } else {
      }
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    await _cameraController?.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(
          builder: (context) => PhotoScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Une erreur est survenue lors de l'extraction du texte."),
        ),
      );
    }
  }

  
}
