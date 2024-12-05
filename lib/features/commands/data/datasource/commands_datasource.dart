import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

import '../../../../core/api/base_api.dart';
import '../../../../core/api/ffi_helpers.dart';
import '../model/command_message.dart';

class CommandsAPI extends API {
  static final CommandsAPI _instance = CommandsAPI._internal();

  static CommandsAPI get instance => _instance;

  CommandsAPI._internal();

  static Future<List<CommandMessage>> sendCommandsAsync(List<CommandMessage> commands, Pointer<XIMU3_Connection> connection) async {
    List<CommandMessage> responses = [];

    for (final CommandMessage command in commands) {
      final response = Completer<List<String>>();

      void callback(XIMU3_CharArrays data, ffi.Pointer<ffi.Void> context) {
        response.complete(_toListOfStringsAndFree(data));
      }

      ffi.Pointer<ffi.Pointer<Utf8>> pointer = FFIHelpers.convertListToPointerPointer([command.json]);
      API.api.XIMU3_connection_send_commands_async(connection, pointer.cast(), 1, 2, 500, NativeCallable<
          ffi.Void Function(XIMU3_CharArrays data,
              ffi.Pointer<ffi.Void> context)>.listener(callback)
          .nativeFunction,
          ffi.nullptr);
      calloc.free(pointer);

      await response.future.then((response) {
          if (response.isNotEmpty) {
              responses.add(CommandMessage.fromJson(response.first));
      }});
    }

    return responses;
  }

  // TODO: Fix for char arrays containing multiple strings
  static List<String> _toListOfStringsAndFree(XIMU3_CharArrays charArrays) {
    List<String> strings = [];
    for (int i = 0; i < charArrays.length; i++) {
      strings.add((charArrays.array + i).cast<Utf8>().toDartString());
    }
    API.api.XIMU3_char_arrays_free(charArrays);
    return strings;
  }
}
