import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';

// enum SizeScale { xs, sm, md, lg, xl, xxl, xxxl }

enum TextFont {
  dmSansRegular,
  onestBold,
  interThin,
  jakartaSansMedium,
  interLight,
}

class AppTextStyle {
  final BuildContext context;

  AppTextStyle(this.context);

  /// Returns a font size based on the given [SizeScale].
  double _fontSize(SizeScale size) {
    final screenHeight = MediaQuery.of(context).size.height;
    switch (size) {
      case SizeScale.xs:
        return screenHeight * (1.65 / 100); // ~12
      case SizeScale.sm:
        return screenHeight * (1.93 / 100); // ~14
      case SizeScale.md:
        return screenHeight * (2.2 / 100); // ~16
      case SizeScale.lg:
        return screenHeight * (2.25 / 100); // ~18
      case SizeScale.xl:
        return screenHeight * (2.75 / 100); // ~20
      case SizeScale.xxl:
        return screenHeight * (3.3 / 100); // ~24
      case SizeScale.xxxl:
        return screenHeight * (4.13 / 100); // ~30
    }
  }

  /// Returns the font family based on [TextFont]
  String _getFontFamily(TextFont font) {
    switch (font) {
      case TextFont.dmSansRegular:
        return 'DmSans Regular';
      case TextFont.onestBold:
        return 'Onest Bold';
      case TextFont.interThin:
        return 'Inter Thin';
      case TextFont.jakartaSansMedium:
        return 'PlusJakartaSans Medium';
      case TextFont.interLight:
        return 'Inter Light';
    }
  }

  /// Returns the default fontWeight based on [TextFont]
  FontWeight _getFontWeight(TextFont font) {
    switch (font) {
      case TextFont.dmSansRegular:
        return FontWeight.normal;
      case TextFont.onestBold:
        return FontWeight.bold;
      case TextFont.interThin:
        return FontWeight.w100;
      case TextFont.jakartaSansMedium:
        return FontWeight.w500;
      case TextFont.interLight:
        return FontWeight.w300;
    }
  }

  /// Returns the line height multiplier based on [SizeScale]
  double _getLineHeight(SizeScale size) {
    switch (size) {
      case SizeScale.xs:
        return 1.2;
      case SizeScale.sm:
        return 1.25;
      case SizeScale.md:
        return 1.3;
      case SizeScale.lg:
        return 1.35;
      case SizeScale.xl:
        return 1.4;
      case SizeScale.xxl:
        return 1.45;
      case SizeScale.xxxl:
        return 1.5;
    }
  }

  /// Main method to get text style
  TextStyle style({
    required TextFont font,
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height, // Overrides the default line height if provided
  }) {
    return TextStyle(
      fontFamily: _getFontFamily(font),
      fontSize: _fontSize(size),
      fontWeight: fontWeight ?? _getFontWeight(font),
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height ?? _getLineHeight(size),
    );
  }

  // Convenience methods for each font type
  TextStyle dmSansRegular({
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return style(
      font: TextFont.dmSansRegular,
      size: size,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle onestBold({
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return style(
      font: TextFont.onestBold,
      size: size,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle interThin({
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return style(
      font: TextFont.interThin,
      size: size,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle jakartaSansMedium({
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return style(
      font: TextFont.jakartaSansMedium,
      size: size,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle interLight({
    required SizeScale size,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return style(
      font: TextFont.interLight,
      size: size,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }
}

extension AppTextStyleExtension on BuildContext {
  AppTextStyle get textStyle => AppTextStyle(this);
}
