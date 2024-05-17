import 'package:flutter/material.dart';

import '../utils/palette.dart';

class AppCheckboxListTile extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;
  final Widget content;

  const AppCheckboxListTile({
    Key? key,
    required this.checked,
    required this.onChanged,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: content,
      leading: SizedBox(
        width: 25,
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomCheckbox(
            value: checked,
            onChanged: onChanged,
          ),
        ),
      ),
      onTap: () => onChanged(!checked),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(color: Palette.backgroundDarkest, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            color: value ? Palette.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
