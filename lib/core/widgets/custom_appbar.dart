import 'package:flutter/material.dart';

import '../utils/index.dart';
import 'app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton,
  }) : super(key: key);

  final String title;
  final bool? showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: showBackButton ?? true,
      iconTheme: const IconThemeData(
        color: Palette.white,
      ),
      titleSpacing: 0,
      backgroundColor: Palette.backgroundDarkest,
      elevation: 0,
      title: AppText(
        text: title,
        weight: Weight.medium,
        size: SizeFont.L,
      ),
    );
  }
}
