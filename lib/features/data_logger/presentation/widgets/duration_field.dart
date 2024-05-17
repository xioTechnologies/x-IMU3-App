import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';

double calculateTextWidth(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.width;
}

class DurationDisplay extends StatelessWidget {
  final String duration;

  const DurationDisplay({Key? key, required this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Palette.white,
      fontFamily: FontUtils.fontFamily,
      fontSize: 18,
    );

    final textWidth = calculateTextWidth(Strings.stopwatchPlaceholder, textStyle);

    return Container(
      decoration: BoxDecoration(
        color: Palette.backgroundDarkest,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Container(
          width: textWidth * 1.45,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppText(
            text: duration,
            size: SizeFont.xxL,
            align: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
