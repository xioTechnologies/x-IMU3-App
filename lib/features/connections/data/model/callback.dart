import 'dart:async';

class Callback<T> {
  int? callbackId;
  StreamController<List<T>> streamController;
  List<T> data = [];
  List<String> keys;

  Callback({
    required this.callbackId,
    required this.streamController,
    required this.keys,
    this.data = const [],
  });

  void clear() {
    streamController.close();
    data = <T>[];
    callbackId = null;
  }
}
