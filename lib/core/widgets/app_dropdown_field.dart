import 'package:flutter/material.dart';

import '../../features/device_settings/data/model/device_settings_setting.dart';
import '../utils/index.dart';
import 'app_text.dart';

class AppDropdownField extends StatefulWidget {
  const AppDropdownField({
    super.key,
    required this.options,
    required this.onSelected,
    this.selectedValue,
    this.enabled = true,
    this.label,
  });
  final bool enabled;
  final String? label;
  final List<Enumerator> options;
  final Enumerator? selectedValue;
  final Function(Enumerator?) onSelected;

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null)
          AppText(
            text: widget.label!,
            align: TextAlign.left,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                child: DropdownButton<Enumerator>(
                  value: widget.selectedValue,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Palette.unselected,
                  ),
                  elevation: 3,
                  isDense: true,
                  dropdownColor: Palette.white,
                  style: const TextStyle(color: Palette.backgroundDark)
                      .copyWith(fontFamily: FontUtils.fontFamily),
                  onChanged: (Enumerator? value) {
                    widget.onSelected(value);
                  },
                  items: widget.options.map((Enumerator value) {
                    return DropdownMenuItem<Enumerator>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AppText(
                          text: value.name,
                          color: Palette.backgroundDark,
                          size: SizeFont.M,
                          weight: Weight.regular,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
