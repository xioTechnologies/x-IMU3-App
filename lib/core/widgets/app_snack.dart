import 'package:flutter/material.dart';

import '../utils/palette.dart';
import 'app_text.dart';

class AppSnack {
  /// [String] Message to display
  ///
  /// [int] Duration in milliseconds
  static show(
    BuildContext context, {
    required String message,
    int duration = 5000,
    bool fromTop = false,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
        backgroundColor: Palette.backgroundDarkest,
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: AppText(text: message, align: TextAlign.center),
        ),
        margin: fromTop
            ? EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 200,
                right: 20,
                left: 20,
              )
            : const EdgeInsets.only(
                right: 20,
                left: 20,
                bottom: 20,
              ),
      ),
    );
  }
}
