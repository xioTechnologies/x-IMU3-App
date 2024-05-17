import 'package:flutter/material.dart';

import '../utils/index.dart';

class AppText extends StatelessWidget {
  /// Standard [Text] widget
  ///
  /// [SizeFont] and [Text] are required parameters
  ///
  const AppText({
    Key? key,
    required this.text,
    this.weight,
    this.size,
    this.align = TextAlign.left,
    this.maxLines = 10,
    this.color = Palette.white,
  }) : super(key: key);

  final String text;

  final Weight? weight;
  final SizeFont? size;
  final Color? color;

  ///Optional - defaults to [TextAlign.left]
  final TextAlign align;

  ///Optional - defaults to [1]
  final int maxLines;

  final height = 1.2;
  final letterSpacing = 0.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: FontUtils.fontFamily,
        fontSize: FontUtils.getFontSize(size ?? SizeFont.M),
        fontWeight: FontUtils.getFontWeight(weight ?? Weight.regular),
        height: height,
        letterSpacing: letterSpacing,
      ),
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
