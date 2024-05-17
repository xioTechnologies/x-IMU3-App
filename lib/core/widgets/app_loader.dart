import 'package:flutter/material.dart';

import '../utils/palette.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key, this.show = true}) : super(key: key);
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      child: const Center(
        child: CircularProgressIndicator(
          color: Palette.white,
          backgroundColor: Palette.backgroundDark,
        ),
      ),
    );
  }
}
