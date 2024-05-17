import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/palette.dart';
import '../utils/font_utils.dart';

class AppSearchBarFilter extends StatefulWidget {
  const AppSearchBarFilter({
    super.key,
    required this.hintText,
    required this.value,
    required this.onEnter,
    required this.onType,
    required this.onCancel,
    required this.filterTapped,
    this.showFilter = true,
    this.initialSearch,
    this.showDot = false,
  });

  final String hintText;
  final String value;
  final Function(String) onEnter;
  final Function(String) onType;
  final VoidCallback onCancel;
  final VoidCallback filterTapped;
  final bool showDot;
  final String? initialSearch;
  final bool showFilter;

  @override
  State<AppSearchBarFilter> createState() => _AppSearchBarFilterState();
}

class _AppSearchBarFilterState extends State<AppSearchBarFilter> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null) {
      controller.text = widget.initialSearch!;
    }
    controller.addListener(listener);
  }

  void listener() {
    widget.onType(controller.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              style:
                  const TextStyle(color: Palette.white).copyWith(fontFamily: FontUtils.fontFamily),
              placeholderStyle: const TextStyle(color: Palette.unselected)
                  .copyWith(fontFamily: FontUtils.fontFamily),
              padding: const EdgeInsets.all(15),
              placeholder: widget.hintText,
              decoration: BoxDecoration(
                color: Palette.backgroundDark,
                borderRadius: BorderRadius.circular(5),
              ),
              controller: controller,
              keyboardType: TextInputType.text,
            ),
          ),
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Palette.backgroundDark,
                    ),
                    child: IconButton(
                      onPressed: () => widget.filterTapped(),
                      icon: const Icon(
                        Icons.filter_alt,
                        color: Palette.white,
                        size: 35,
                      ),
                    ),
                  ),
                  if (widget.showDot)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Palette.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
