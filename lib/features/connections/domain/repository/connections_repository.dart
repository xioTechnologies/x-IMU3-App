import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/data/model/network_announcement_callback_result.dart';
import 'package:ximu3_app/features/connections/domain/usecases/new_manual_udp_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/add_network_announcement_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/remove_network_announcement_usecase.dart';

import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/usecase/failures.dart';
import '../../data/datasource/connections_datasource.dart';
import '../../data/model/connection.dart';
import '../usecases/new_connection_usecase.dart';
import '../usecases/remove_connection_usecase.dart';

abstract class ConnectionsRepository {
  Future<Either<Failure, List<Connection>>> getAvailableConnectionsAsync(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer);

  Either<Failure, Pointer<XIMU3_Connection>?> newConnection(NewConnectionUseCaseParams params);

  Either<Failure, Pointer<XIMU3_Connection>?> newManualUDPConnection(
      NewManualUDPConnectionUseCaseParams params);

  Either<Failure, dynamic> removeConnection(RemoveConnectionUseCaseParams params);

  Either<Failure, NetworkAnnouncementCallbackResult?> addNetworkAnnouncementCallback(
      AddNetworkAnnouncementUseCaseParams params);

  Either<Failure, dynamic> removeNetworkAnnouncementCallback(
      RemoveNetworkAnnouncementUseCaseParams params);
}

class ConnectionsRepositoryImpl extends ConnectionsRepository {
  ConnectionsAPI api = ConnectionsAPI.instance;

  @override
  Future<Either<Failure, List<Connection>>> getAvailableConnectionsAsync(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer) async {
    try {
      final results = await Future.wait([
        api.getAvailableConnectionsAsync(),
        api.getMessagesAfterShortDelayAsync(networkAnnouncementPointer),
      ]);

      final List<Connection> allConnections =
          results.expand((element) => element.whereType<Connection>()).toList();

      return Right(allConnections);
    } catch (error) {
      return Left(DefaultFailure(error.toString()));
    }
  }

  @override
  Either<Failure, Pointer<XIMU3_Connection>?> newManualUDPConnection(
      NewManualUDPConnectionUseCaseParams params) {
    try {
      Pointer<XIMU3_Connection>? connectionPointer = api.newManualUDPConnection(
        params.ipAddress,
        params.sendPort,
        params.receivePort,
      );

      if (connectionPointer != null) {
        return Right(connectionPointer);
      } else {
        throw 'Unable to connect';
      }
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Either<Failure, Pointer<XIMU3_Connection>?> newConnection(NewConnectionUseCaseParams params) {
    try {
      Pointer<XIMU3_Connection>? connectionPointer = api.newConnection(params.connection!);

      if (connectionPointer != null) {
        return Right(connectionPointer);
      } else {
        throw 'Unable to connect';
      }
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Either<Failure, dynamic> removeConnection(RemoveConnectionUseCaseParams params) {
    try {
      final data = api.removeConnection(params.connections, params.cubit);
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Either<Failure, NetworkAnnouncementCallbackResult?> addNetworkAnnouncementCallback(
      AddNetworkAnnouncementUseCaseParams params) {
    try {
      final data = api.addNetworkAnnouncementCallback(params);
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Either<Failure, dynamic> removeNetworkAnnouncementCallback(
      RemoveNetworkAnnouncementUseCaseParams params) {
    try {
      api.removeNetworkAnnouncementCallback(callbackId: params.callbackId, pointer: params.pointer);
      return const Right(true);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }
}
