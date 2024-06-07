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

  NativeLibrary get api => API.api;

  static Future<List<CommandMessage>> sendCommandAsync(List<CommandMessage> commands, Pointer<XIMU3_Connection> connection) async {
    List<CommandMessage> responses = [];

    final completer = Completer<XIMU3_CharArrays>();

    void callback(XIMU3_CharArrays data, ffi.Pointer<ffi.Void> context) {
      completer.complete(data);
    }

    final List<String> strings = List.generate(commands.length, (index) => commands[index].toJson());
    ffi.Pointer<ffi.Pointer<Utf8>> pointer = FFIHelpers.convertListToPointerPointer(strings);
    _instance.api.XIMU3_connection_send_commands_async(connection, pointer.cast(), commands.length, 2, 500, NativeCallable<
        ffi.Void Function(XIMU3_CharArrays data,
            ffi.Pointer<ffi.Void> context)>.listener(callback)
        .nativeFunction,
        ffi.nullptr);
    calloc.free(pointer);

    await completer.future.then((XIMU3_CharArrays data) {
      List<String> strings = _toListOfStringsAndFree(data);
      responses = List.generate(strings.length, (index) => CommandMessage.fromJson(strings[index]));
    });

    return responses;
  }

  static List<String> _toListOfStringsAndFree(XIMU3_CharArrays charArrays) {
    List<String> strings = [];
    for (int i = 0; i < charArrays.length; i++) {
      strings.add((charArrays.array + (i * XIMU3_CHAR_ARRAY_SIZE) ~/ 8).cast<Utf8>().toDartString()); // TODO: Why does this work?
    }
     _instance.api.XIMU3_char_arrays_free(charArrays);
    return strings;
  }
}
