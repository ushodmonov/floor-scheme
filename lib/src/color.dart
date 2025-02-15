import 'package:flutter/material.dart';

Color hexToColor(String hexCode) {
  // Ensure the string starts with '0xFF' for full opacity
  final formattedHex = hexCode.replaceFirst('#', '').padLeft(8, 'FF');
  return Color(int.parse(formattedHex, radix: 16));
}
