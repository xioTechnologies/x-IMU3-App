import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/index.dart';
import 'app_text.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    this.enabled = true,
    this.label,
    this.placeholder,
    this.centered = false,
    this.onDone,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final bool enabled;
  final String? label;
  final String? placeholder;
  final bool centered;
  final Function(String)? onDone;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          AppText(
            text: label!,
            align: TextAlign.left,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: enabled ? _buildTextField() : _buildSelectableText(),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return GestureDetector(
      onTap: () {},
      child: CupertinoTextField(
        textAlign: centered ? TextAlign.center : TextAlign.left,
        cursorColor: Palette.backgroundDark,
        cursorWidth: 1.0,
        style: const TextStyle(color: Palette.backgroundDark, fontSize: 16)
            .copyWith(fontFamily: FontUtils.fontFamily),
        placeholder: placeholder,
        placeholderStyle:
            const TextStyle(color: Palette.unselected).copyWith(fontFamily: FontUtils.fontFamily),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(5),
        ),
        controller: controller,
        keyboardType: TextInputType.text,
        onSubmitted: (str) {
          if (onDone != null) {
            onDone!(str);
          }
        },
        onChanged: (str) {
          if (onChanged != null) {
            onChanged!(str);
          }
        },
      ),
    );
  }

  Widget _buildSelectableText() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.unselected,
        borderRadius: BorderRadius.circular(5),
      ),
      child: SelectableText(
        controller.text.isEmpty ? placeholder ?? '' : controller.text,
        style: const TextStyle(color: Palette.backgroundDark, fontSize: 16)
            .copyWith(fontFamily: FontUtils.fontFamily),
        textAlign: centered ? TextAlign.center : TextAlign.left,
        cursorColor: Palette.backgroundDark,
        showCursor: true,
        toolbarOptions: const ToolbarOptions(
          copy: true,
          selectAll: true,
          cut: false,
          paste: false,
        ),
      ),
    );
  }
}
