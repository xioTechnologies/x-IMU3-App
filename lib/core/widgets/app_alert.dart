import 'package:flutter/material.dart';

import '../utils/palette.dart';

class AppAlertDialog {
  static show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> buttonTitles,
    required Function(int) buttonTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.backgroundDarkest.withOpacity(0.8),
      builder: (BuildContext ctx) {
        return AlertDialog.adaptive(
          key: const Key('dialogKey'),
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                buttonTap(0);
              },
              child: Text(buttonTitles[0]),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                buttonTap(1);
              },
              child: Text(buttonTitles[1]),
            ),
          ],
        );
      },
    );
  }
}
