import 'package:digit_classification/main.dart';
import 'package:gesture_reckognition/main.dart';
import 'package:live_detection/ui/home_view.dart';
import 'package:flutter/material.dart';

const List<Map<String, Object>> featureMap = [
  {
    'name': 'Live detection',
    'widget': LiveObjectDetectScreen(),
    'icon': Icons.camera
  },
  {
    'name': 'Gesture reckognition',
    'widget': GesturesScreen(),
    'icon': Icons.sign_language
  },
  {
    'name': 'Digit classification',
    'widget': DigitClassificationScreen(),
    'icon': Icons.numbers
  },
  {
    'name': 'Search insights',
    'widget': LiveObjectDetectScreen(),
    'icon': Icons.question_answer
  },
  {
    'name': 'Speech reckognition',
    'widget': LiveObjectDetectScreen(),
    'icon': Icons.mic
  },
  {
    'name': 'AI battleships',
    'widget': LiveObjectDetectScreen(),
    'icon': Icons.gamepad
  },
];
