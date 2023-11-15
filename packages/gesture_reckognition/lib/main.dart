/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gesture_reckognition/helper/gesture_classification_helper.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture classification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const GesturesScreen(),
    );
  }
}

class GesturesScreen extends StatefulWidget {
  const GesturesScreen({super.key});

  @override
  State<GesturesScreen> createState() => _GesturesScreenState();
}

class _GesturesScreenState extends State<GesturesScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  late GestureClassificationHelper _gestureClassificationHelper;
  Map<String, double>? _classification;
  bool _isProcessing = false;
  late List<CameraDescription> cameras;
  // use only when initialized, so - not null
  get _controller => _cameraController;

  /// Initializes the camera by setting [_cameraController]
  void _initCamera() async {
    cameras = await availableCameras();
    // cameras[0] for back-camera
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    )..initialize().then((_) async {
        await _controller.startImageStream(_imageAnalysis);
        setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize = _controller.value.previewSize!;
      });
  }

  // // init camera
  // _initCamera() {
  //   _cameraDescription = _cameras.firstWhere(
  //       (element) => element.lensDirection == CameraLensDirection.front);
  //   _cameraController = CameraController(
  //       _cameraDescription, ResolutionPreset.medium,
  //       imageFormatGroup: Platform.isIOS
  //           ? ImageFormatGroup.bgra8888
  //           : ImageFormatGroup.yuv420);
  //   _cameraController!.initialize().then((value) {
  //     _cameraController!.startImageStream(_imageAnalysis);
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  // }

  Future<void> _imageAnalysis(CameraImage cameraImage) async {
    // if image is still analyze, skip this frame
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    _classification =
        await _gestureClassificationHelper.inferenceCameraFrame(cameraImage);
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  // this function using config camera and init model
  _initHelper() {
    _initCamera();
    _gestureClassificationHelper = GestureClassificationHelper();
    _gestureClassificationHelper.init();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initHelper();
    });
  }

  // handle app lifecycle state change (pause/resume)
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (_cameraController != null &&
            !_cameraController!.value.isStreamingImages) {
          await _cameraController!.startImageStream(_imageAnalysis);
        }
        break;
      default:
    }
  }

  // dispose camera
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _gestureClassificationHelper.close();
    super.dispose();
  }

  Widget cameraWidget(context) {
    if (_cameraController == null) return Container();

    // get current camera preview size
    var camera = _cameraController!.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Image.asset(
          const AssetImage('assets/images/tfl_logo.png').assetName,
          package: 'gesture_reckognition',
        )),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Stack(
        children: [
          SizedBox(
            child: cameraWidget(context),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_classification != null)
                    ...(_classification!.entries.toList()
                          ..sort(
                            (a, b) => a.value.compareTo(b.value),
                          ))
                        .reversed
                        .take(3)
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Text(e.key),
                                const Spacer(),
                                Text(e.value.toStringAsFixed(2))
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class ScreenParams {
  static late Size screenSize;
  static late Size previewSize;

  static double previewRatio = max(previewSize.height, previewSize.width) /
      min(previewSize.height, previewSize.width);

  static Size screenPreviewSize =
      Size(screenSize.width, screenSize.width * previewRatio);
}
