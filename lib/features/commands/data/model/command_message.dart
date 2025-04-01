import 'dart:convert';

import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';
import '../../../../core/api/base_api.dart';
import '../../../../core/api/ffi_helpers.dart';

class CommandMessage {
  late String json;
  late String key;
  late dynamic value;
  late String? error;

  CommandMessage(this.key, this.value)
  {
    json = "{\"$key\":";
    if (value == null) {
      json += "null";
    } else if (value is String) {
      json += "\"$value\"";
    } else {
      json += value.toString();
    }
    json += "}";
    error = null;
  }

  CommandMessage.fromJson(final String string) {
    final XIMU3_CommandMessage commandMessage = API.api.XIMU3_command_message_parse(FFIHelpers.stringToPointerChar(string));
    json = FFIHelpers.convertCharArrayToString(commandMessage.json);
    key = FFIHelpers.convertCharArrayToString(commandMessage.key);
    value = jsonDecode(FFIHelpers.convertCharArrayToString(commandMessage.value));
    final String errorString = FFIHelpers.convertCharArrayToString(commandMessage.error);
    error = errorString.isNotEmpty ? errorString : null;
  }
}
