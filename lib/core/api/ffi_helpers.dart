import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

import '../../features/connections/data/model/connection.dart';

class FFIHelpers {
  static String convertCharArrayToString(Array<Char> charArray) {
    StringBuffer stringBuffer = StringBuffer();

    for (int j = 0; j < XIMU3_CHAR_ARRAY_SIZE; j++) {
      int charCode = charArray[j];
      if (charCode == 0) {
        break;
      }
      if (charCode != null) {
        stringBuffer.writeCharCode(charCode);
      }
    }
    return stringBuffer.toString();
  }

  static ffi.Pointer<ffi.Pointer<Utf8>> convertListToPointerPointer(List<String> commands) {
    var pointers = commands.map((command) {
      return command.toNativeUtf8();
    }).toList();

    final pointerList = calloc<ffi.Pointer<Utf8>>(pointers.length);

    for (var i = 0; i < pointers.length; i++) {
      pointerList[i] = pointers[i];
    }

    return pointerList;
  }

  static Pointer<Char> stringToPointerChar(String input) {
    final Pointer<Char> result = calloc<Char>(input.length + 1);

    final List<int> units = utf8.encode(input);
    final Uint8List list = Uint8List.fromList(units);
    final Pointer<Uint8> ptr = result.cast<Uint8>();
    for (int i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }

    ptr.elementAt(input.length).value = 0;

    return result;
  }

  static Pointer<Pointer<XIMU3_Connection>> convertConnectionsToPointer(List<Connection> connections) {
    final Pointer<Pointer<XIMU3_Connection>> connectionsPtr = calloc<Pointer<XIMU3_Connection>>(connections.length);

    for (int i = 0; i < connections.length; i++) {
      if (connections[i].connectionPointer != null) {
        connectionsPtr[i] = connections[i].connectionPointer!;
      } else {
        connectionsPtr[i] = Pointer.fromAddress(0);
      }
    }

    return connectionsPtr;
  }
}
