import 'device_settings_setting.dart';

class DeviceSettingsGroup {
  final String name;
  final String hideKey;
  final List<String> hideValues;

  List<DeviceSettingsSetting> settings;
  Map<String, DeviceSettingsGroup> subGroups;
  bool expanded;

  DeviceSettingsGroup({
    required this.name,
    required this.hideKey,
    required this.hideValues,
    this.settings = const [],
    this.subGroups = const {},
    required this.expanded,
  });
}
