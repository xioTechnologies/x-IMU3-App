import 'dart:ffi';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

import '../../../../core/api/base_api.dart';
import '../../../../core/api/ffi_helpers.dart';
import '../../../../core/utils/utils.dart';
import '../../../connections/data/model/connection.dart';
import '../model/session.model.dart';

class DataLoggerAPI {
  static final DataLoggerAPI _instance = DataLoggerAPI._internal();
  static DataLoggerAPI get instance => _instance;

  DataLoggerAPI._internal();

  static NativeLibrary get api => API.api;

  Pointer<XIMU3_DataLogger>? dataLoggerPointer;

  Future<bool> openSession(String sessionName, List<Connection> connections) async {
    final Pointer<Char> directoryPointer = await getDirectoryPointer();

    final Pointer<Char> sessionNamePointer = FFIHelpers.stringToPointerChar(sessionName);

    final Pointer<Pointer<XIMU3_Connection>> connectionsPointer =
        FFIHelpers.convertConnectionsToPointer(connections);

    dataLoggerPointer = api.XIMU3_data_logger_new(
        directoryPointer, sessionNamePointer, connectionsPointer, connections.length);

    calloc.free(directoryPointer);
    calloc.free(sessionNamePointer);
    calloc.free(connectionsPointer);

    if (dataLoggerPointer != null) {
      int result = api.XIMU3_data_logger_get_result(dataLoggerPointer!);

      Pointer<Char> resultString = api.XIMU3_result_to_string(result);
      print("Data logger result: ${resultString.cast<Utf8>().toDartString()}");
      return true;
    } else {
      return false;
    }
  }

  Future<Pointer<Char>> getDirectoryPointer() async {
    final directory = await getApplicationDocumentsDirectory();
    final sessionFolder = Directory(directory.path);
    print('Session directory: $sessionFolder');
    return FFIHelpers.stringToPointerChar(sessionFolder.path);
  }

  Future<bool> stopSession(String sessionName) async {
    if (dataLoggerPointer != null) {
      await zipSession(sessionName);
      api.XIMU3_data_logger_free(dataLoggerPointer!);
      dataLoggerPointer = null;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteSessionZip(String sessionName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String key = Utils.sessionKey(sessionName);

      final zipFile = File("${directory.path}/$key.zip");

      if (await zipFile.exists()) {
        await zipFile.delete();
        print('Session zip deleted successfully.');
        return true;
      } else {
        throw 'Session zip does not exist';
      }
    } catch (e) {
      throw 'Error deleting session zip: $e';
    }
  }

  Future<bool> zipSession(String sessionName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String key = Utils.sessionKey(sessionName);

      final sessionFolder = "${directory.path}/$key";
      final tempZipPath = "${directory.path}/$key.zip";

      final encoder = ZipFileEncoder();
      encoder.create(tempZipPath);
      encoder.addDirectory(Directory(sessionFolder), includeDirName: false);
      encoder.close();

      final sessionDirectory = Directory(sessionFolder);
      if (await sessionDirectory.exists()) {
        await sessionDirectory.delete(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Session>> getSessions() async {
    List<Session> sessions = await listZipSessions();
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  Future<List<Session>> listZipSessions() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<Session> sessions = [];

    try {
      await for (var entity in Directory(directory.path).list()) {
        if (entity.path.endsWith('.zip')) {
          var fileStat = await entity.stat();
          var lastModified = fileStat.modified;
          var size = fileStat.size / 1024.0;

          var name = basenameWithoutExtension(entity.path);

          sessions.add(
            Session(
              name: name,
              date: lastModified,
              size: double.tryParse(size.toStringAsFixed(2)) ?? 0,
            ),
          );
        }
      }
    } catch (e) {
      print('Error while listing zip sessions: $e');
    }

    return sessions;
  }
}
