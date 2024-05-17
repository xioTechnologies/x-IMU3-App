import 'package:flutter/cupertino.dart';

class DeviceSettingsSetting {
  final String key;
  final String name;
  final String type;
  final bool readOnly;
  final List<Enumerator> items;
  final String hideKey;
  final List<String> hideValues;

  TextEditingController controller;
  dynamic value;

  DeviceSettingsSetting({
    required this.key,
    required this.name,
    required this.type,
    required this.readOnly,
    required this.items,
    required this.hideKey,
    required this.hideValues,
    required this.controller,
    this.value,
  });
}

class Enumerator {
  final String name;
  final dynamic value;

  Enumerator({
    required this.name,
    required this.value,
  });
}
