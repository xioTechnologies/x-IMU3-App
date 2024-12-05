import 'dart:ffi';
import 'dart:io';

import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

class API {
  static final NativeLibrary api = (Platform.isAndroid) ? NativeLibrary(DynamicLibrary.open("libximu3.so")) : NativeLibrary(DynamicLibrary.executable());
}
