import 'dart:ffi';

import '../../../../core/api/ximu3_bindings.g.dart';

class NetworkAnnouncementCallbackResult {
  final int callbackId;
  final Pointer<XIMU3_NetworkAnnouncement> pointer;

  NetworkAnnouncementCallbackResult({
    required this.callbackId,
    required this.pointer,
  });
}
