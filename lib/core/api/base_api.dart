import 'dart:ffi';
import 'dart:io';

import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

abstract class API {
  static late NativeLibrary api;

  API() {
    if (Platform.isAndroid) {
      api = NativeLibrary(DynamicLibrary.open("libximu3.so"));
    } else {
      api = NativeLibrary(DynamicLibrary.executable());
    }
  }
}
