import 'package:flutter/material.dart';
import 'package:live_detection/models/screen_params.dart';
import 'package:live_detection/ui/detector_widget.dart';

/// [LiveObjectDetectScreen] stacks [DetectorWidget]
class LiveObjectDetectScreen extends StatelessWidget {
  const LiveObjectDetectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Image.asset(
        AssetImage('assets/images/tfl_logo.png').assetName,
        package: 'live_detection',
      ),
      ),
      body: const DetectorWidget(),
    );
  }
}
