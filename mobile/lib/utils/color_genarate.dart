import 'package:flutter/material.dart';

Color generateColorFromString(String input) {
  final hashCode = input.hashCode;
  final hue = (hashCode % 360).toDouble();
  final saturation = ((hashCode & 0x7FFFFFFF) / 0x7FFFFFFF.toDouble()) * 0.5 + 0.5;
  final value = ((hashCode & 0x7FFFFFFF) / 0x7FFFFFFF.toDouble()) * 0.5 + 0.5;
  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}
