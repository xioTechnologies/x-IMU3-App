import 'package:flutter/cupertino.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';

class StorageLabel extends StatelessWidget {
  const StorageLabel({Key? key, required this.label}) : super(key: key);
  final ValueNotifier<String?> label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: label,
      builder: (context, $label, _) {
        if ($label != null && $label.isNotEmpty) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: AppText(
              text: $label,
              size: SizeFont.xS,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
