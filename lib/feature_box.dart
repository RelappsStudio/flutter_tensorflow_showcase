import 'package:flutter/material.dart';

class FeatureBox extends ElevatedButton {
  final int fontSize = 15;
  final Color? color;
  final String? text;
  final IconData? icon;
  FeatureBox({
    super.key,
    this.color,
    this.text,
    this.icon,
    required super.onPressed,
  }) : super(style: _createSquareStyle(color), child: _createChild(text, icon));

  static ButtonStyle _createSquareStyle(Color? color) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 2, color: color ?? Colors.white)),
      backgroundColor: color ?? Colors.transparent,
      elevation: 10,
      minimumSize: const Size(200, 55),
      maximumSize: const Size(300, 300),
    );
  }

  static Widget _createChild(String? text, IconData? icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Icon(icon, size: 50), Text('$text')],
    );
  }
}
