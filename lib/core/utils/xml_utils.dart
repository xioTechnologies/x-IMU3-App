import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ximu3_app/core/utils/strings.dart';
import 'package:ximu3_app/core/utils/utils.dart';
import 'package:xml/xml.dart';

import '../../features/commands/data/model/command_message.dart';
import '../../features/device_settings/data/model/device_settings_setting.dart';
import '../../features/device_settings/data/model/device_settings_group.dart';

final List<Enumerator> boolEnum = [
  Enumerator(name: Strings.disabled, value: false),
  Enumerator(name: Strings.enabled, value: true),
];

class XMLUtils {
  XMLUtils._();

  static const String deviceSettingsXml = "assets/xml/DeviceSettings.xml";
  static const String deviceSettingsEnumsXml = "assets/xml/DeviceSettingsEnums.xml";

  static Future<List<String>> getDeviceSettingsKeys() async {
    final XmlDocument document = XmlDocument.parse(await Utils.loadAsset(deviceSettingsXml));

    final Iterable<XmlElement> settings = document.findAllElements(Strings.setting);

    final List<String> keys = settings
        .map((setting) {
          final String? key = setting.getAttribute(Strings.key);
          return key;
        })
        .whereType<String>()
        .toList();

    return keys;
  }

  static Future<Map<String, DeviceSettingsGroup>> parseDeviceSettings() async {
    Completer<Map<String, DeviceSettingsGroup>> completer = Completer<Map<String, DeviceSettingsGroup>>();
    Map<String, DeviceSettingsGroup> rootGroups = {};
    Map<String, List<Enumerator>> enums = {};
    Map<String, DeviceSettingsGroup> allGroups = {};

    try {
      final document = XmlDocument.parse(await Utils.loadAsset(deviceSettingsXml));
      final enumsDocument = XmlDocument.parse(await Utils.loadAsset(deviceSettingsEnumsXml));

      enumsDocument.findAllElements(Strings.enums).forEach((enumElement) {
        enums[enumElement.getAttribute(Strings.name)!] = enumElement.findElements(Strings.enumerator).map((optionElement) {
          return Enumerator(
            name: optionElement.getAttribute(Strings.name)!,
            value: int.parse(optionElement.getAttribute(Strings.value)!),
          );
        }).toList();
      });

      DeviceSettingsGroup parseGroup(XmlElement groupElement, {String? parentName}) {
        String name = groupElement.getAttribute(Strings.name)!;
        if (allGroups.containsKey(name)) {
          return allGroups[name]!;
        }

        List<DeviceSettingsSetting> settings = [];

        groupElement.findElements(Strings.setting).forEach((settingElement) {
          final String key = settingElement.getAttribute(Strings.key)!;
          final String name = settingElement.getAttribute(Strings.name)!;
          final String type = settingElement.getAttribute(Strings.type)!;
          final bool readOnly = settingElement.getAttribute(Strings.readOnly) == "true";
          final List<Enumerator> items = type == 'bool' ? boolEnum : (enums[type] ?? []);
          final String hideKey = settingElement.getAttribute(Strings.hideKey) ?? "";
          final List<String> hideValues = (settingElement.getAttribute(Strings.hideValues) ?? "").split(' ');

          settings.add(
            DeviceSettingsSetting(
              key: key,
              name: name,
              type: type,
              readOnly: readOnly,
              items: items,
              hideKey: hideKey,
              hideValues: hideValues,
              controller: TextEditingController(),
            ),
          );
        });

        final String hideKey = groupElement.getAttribute(Strings.hideKey) ?? "";
        final List<String> hideValues = (groupElement.getAttribute(Strings.hideValues) ?? "").split(' ');
        
        DeviceSettingsGroup group = DeviceSettingsGroup(
          name: name,
          settings: settings,
          subGroups: {},
          expanded: false,
          hideKey: hideKey,
          hideValues: hideValues,
        );

        allGroups[name] = group;

        groupElement.findElements(Strings.group).forEach((subGroupElement) {
          DeviceSettingsGroup subSection = parseGroup(subGroupElement, parentName: name);
          group.subGroups[subSection.name] = subSection;
        });

        if (parentName == null) {
          rootGroups[name] = group;
        }

        return group;
      }

      document.findAllElements(Strings.group).forEach((groupElement) {
        parseGroup(groupElement);
      });

      completer.complete(rootGroups);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
