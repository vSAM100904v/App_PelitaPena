import 'package:flutter/material.dart';

enum SizeScale { xs, sm, md, lg, xl, xxl, xxxl }

class ResponsiveSizes {
  final BuildContext context;

  ResponsiveSizes(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Returns a space size based on the given [SizeScale].
  ///
  /// The space sizes are as follows:
  ///
  /// * [SizeScale.xs]: ~12
  /// * [SizeScale.sm]: ~14
  /// * [SizeScale.md]: ~16
  /// * [SizeScale.lg]: ~18
  /// * [SizeScale.xl]: ~20
  /// * [SizeScale.xxl]: ~24
  /// * [SizeScale.xxxl]: ~30
  double space(SizeScale size) {
    switch (size) {
      case SizeScale.xs:
        return screenHeight * (1.65 / 100); // ~12 (dari 1.65% height)
      case SizeScale.sm:
        return screenHeight * (1.93 / 100); // ~14 (dari 1.93% height)
      case SizeScale.md:
        return screenHeight * (2.2 / 100); // ~16 (dari 2.2% height)
      case SizeScale.lg:
        return screenHeight * (2.25 / 100); // ~18 (dari 2.25% height)
      case SizeScale.xl:
        return screenHeight * (2.75 / 100); // ~20 (dari 2.75% height)
      case SizeScale.xxl:
        return screenHeight * (3.3 / 100); // ~24 (dari 3.3% height)
      case SizeScale.xxxl:
        return screenHeight * (4.13 / 100); // ~30 (dari 4.13% height)
    }
  }

  /// Returns a font size based on the given [SizeScale].
  ///
  /// The font sizes are as follows:
  ///
  /// * [SizeScale.xs]: ~12
  /// * [SizeScale.sm]: ~14
  /// * [SizeScale.md]: ~16
  /// * [SizeScale.lg]: ~18
  /// * [SizeScale.xl]: ~20
  /// * [SizeScale.xxl]: ~24
  /// * [SizeScale.xxxl]: ~30
  double fontSize(SizeScale size) {
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

  /// Returns a border radius size based on the given [SizeScale].
  ///
  /// The border radius sizes are as follows:
  ///
  /// * [SizeScale.xs]: ~10
  /// * [SizeScale.sm]: ~20
  /// * [SizeScale.md]: ~30
  /// * Default: ~20
  double borderRadius(SizeScale size) {
    switch (size) {
      case SizeScale.xs:
        return screenWidth * (2.78 / 100); // ~10 (dari 2.78% width)
      case SizeScale.sm:
        return screenWidth * (5.56 / 100); // ~20 (dari 5.56% width)
      case SizeScale.md:
        return screenWidth * (8.4 / 100); // ~30 (dari 8.4% width)
      default:
        return screenWidth * (5.56 / 100); // Default: 20
    }
  }

  double widthPercent(double percent) => screenWidth * (percent / 100);
  double heightPercent(double percent) => screenHeight * (percent / 100);
}

extension ResponsiveSizesExtension on BuildContext {
  ResponsiveSizes get responsive => ResponsiveSizes(this);
}
