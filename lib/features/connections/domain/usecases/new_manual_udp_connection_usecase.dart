import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/domain/repository/connections_repository.dart';

import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';

class NewManualUDPConnectionUseCase {
  ConnectionsRepository repository;

  NewManualUDPConnectionUseCase(this.repository);

  Either<Failure, Pointer<XIMU3_Connection>?> call(NewManualUDPConnectionUseCaseParams params) {
    return repository.newManualUDPConnection(params);
  }
}

class NewManualUDPConnectionUseCaseParams extends BaseParams {
  final String ipAddress;
  final int sendPort;
  final int receivePort;

  NewManualUDPConnectionUseCaseParams(
      {required this.ipAddress, required this.sendPort, required this.receivePort});

  @override
  List<Object?> get props => [ipAddress, sendPort, receivePort];
}
