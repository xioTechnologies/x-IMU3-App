import 'package:flutter/material.dart';

import '../../features/device_settings/data/model/device_settings_group.dart';
import '../utils/index.dart';
import 'app_text.dart';

class AppExpansionTile extends StatelessWidget {
  const AppExpansionTile({
    Key? key,
    required this.group,
    required this.onExpansionChanged,
    required this.children,
  }) : super(key: key);

  final DeviceSettingsGroup group;
  final Function(bool) onExpansionChanged;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      minVerticalPadding: 0,
      horizontalTitleGap: 10.0,
      minLeadingWidth: 0.0,
      contentPadding: EdgeInsets.zero,
      child: ExpansionTile(
        initiallyExpanded: group.expanded,
        childrenPadding: const EdgeInsets.only(left: 10),
        tilePadding: EdgeInsets.zero,
        onExpansionChanged: (bool isExpanded) {
          onExpansionChanged(isExpanded);
        },
        title: AppText(
          text: group.name,
          weight: Weight.medium,
        ),
        leading: Icon(
          group.expanded ? Icons.expand_more : Icons.chevron_right,
          color: Palette.white,
        ),
        trailing: const SizedBox.shrink(),
        children: children,
      ),
    );
  }
}
