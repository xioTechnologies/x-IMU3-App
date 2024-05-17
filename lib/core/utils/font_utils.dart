import 'package:flutter/material.dart';

enum Weight { regular, medium }

enum Style { normal, italic }

enum SizeFont { xS, S, M, L, xL, xxL }

class FontUtils {
  FontUtils._();

  static const fontFamily = 'Montserrat';

  static FontWeight getFontWeight(Weight weight) {
    switch (weight) {
      case Weight.regular:
        return FontWeight.w400;
      case Weight.medium:
        return FontWeight.w500;
    }
  }

  static FontStyle getFontStyle(Style style) {
    switch (style) {
      case Style.normal:
        return FontStyle.normal;
      case Style.italic:
        return FontStyle.italic;
    }
  }

  static double getFontSize(SizeFont size) {
    switch (size) {
      case SizeFont.xS:
        return 12;
      case SizeFont.S:
        return 14;
      case SizeFont.M:
        return 16;
      case SizeFont.L:
        return 18;
      case SizeFont.xL:
        return 20;
      case SizeFont.xxL:
        return 22;
    }
  }
}
