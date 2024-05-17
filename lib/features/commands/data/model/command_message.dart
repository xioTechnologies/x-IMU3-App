import 'dart:convert';

import 'package:fpdart/fpdart.dart';

class CommandMessage {
  String key;
  dynamic value;

  CommandMessage({
    required this.key,
    required this.value,
  });

  CommandMessage.fromJson(final String string) : key = "" {
    final Map<String, dynamic> json = jsonDecode(string);

    if (json.size > 0) {
      key = json.keys.first;
      value = json.values.first;
    }
  }

  String toJson() {
    String json = "{\"$key\":";

    if (value == null) {
      json += "null";
    } else if (value is String) {
      json += "\"$value\"";
    } else {
      json += value.toString();
    }

    return "$json}";
  }

  String? getError() {
    if (value is Map<String, dynamic> && (value as Map<String, dynamic>).containsKey("error")) {
      return (value as Map<String, dynamic>)["error"];
    }
    return null;
  }
}
