import 'package:flutter/material.dart';
import 'package:ximu3_app/core/utils/palette.dart';

import '../utils/constants.dart';
import '../utils/font_utils.dart';
import 'app_loader.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  /// Standard [TextButton] widget
  ///
  const AppButton({
    Key? key,
    required this.buttonText,
    required this.buttonTapped,
    this.buttonHeight = 50.0,
    this.borderRadius = 5.0,
    this.buttonTextSize,
    this.buttonColor = Palette.white,
    this.textColor = Palette.backgroundDark,
    this.enabled = true,
    this.buttonTextWeight,
    this.icon,
    this.loading = false,
  }) : super(key: key);

  final double buttonHeight;
  final double borderRadius;
  final SizeFont? buttonTextSize;
  final Weight? buttonTextWeight;
  final Color buttonColor;
  final Color? textColor;
  final bool enabled;
  final VoidCallback buttonTapped;
  final String buttonText;
  final Icon? icon;
  final bool loading;

  const AppButton.secondary({
    Key? key,
    required this.buttonTapped,
    required this.buttonText,
    this.enabled = true,
    this.buttonHeight = 50,
    this.buttonTextSize,
    this.buttonTextWeight,
    this.icon,
    this.loading = false,
  })  : buttonColor = Palette.backgroundLightest,
        textColor = Palette.white,
        borderRadius = 5,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            !enabled ? buttonColor.withOpacity(Constants.opacity) : buttonColor,
          ),
        ),
        onPressed: () {
          if (!enabled) {
            return;
          } else {
            buttonTapped();
          }
        },
        child: icon == null
            ? loading
                ? const AppLoader()
                : AppText(
                    text: buttonText,
                    color: textColor ?? Palette.backgroundDarkest,
                    weight: buttonTextWeight ?? Weight.medium,
                    size: buttonTextSize ?? SizeFont.L,
                  )
            : icon!,
      ),
    );
  }
}
