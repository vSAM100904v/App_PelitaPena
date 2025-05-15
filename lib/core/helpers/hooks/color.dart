import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color get contrastTextColor {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Color get smartTextColor {
    final hsl = HSLColor.fromColor(this);
    return computeLuminance() > 0.5
        ? HSLColor.fromColor(
          Colors.black,
        ).withLightness(0.3).withSaturation(0.8).toColor()
        : HSLColor.fromColor(
          Colors.white,
        ).withLightness(0.9).withSaturation(0.6).toColor();
  }
}

Color getSmartTextColor(Color backgroundColor, {double saturationBoost = 1.0}) {
  final hsl = HSLColor.fromColor(backgroundColor);
  final luminance = backgroundColor.computeLuminance();

  return luminance > 0.5
      ? HSLColor.fromColor(Colors.black)
          .withLightness(0.2) // Lebih gelap
          .withSaturation(saturationBoost)
          .toColor()
      : HSLColor.fromColor(Colors.white)
          .withLightness(0.95) // Lebih terang
          .withSaturation(saturationBoost)
          .toColor();
}
