import 'package:flutter/cupertino.dart';

import '../utils/palette.dart';
import 'app_text.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        text: label,
        color: Palette.unselected,
      ),
    );
  }
}
