import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/domain/repository/connections_repository.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../../data/model/connection.dart';

class NewConnectionUseCase {
  ConnectionsRepository repository;

  NewConnectionUseCase(this.repository);

  Either<Failure, Pointer<XIMU3_Connection>?> call(NewConnectionUseCaseParams params) {
    return repository.newConnection(params);
  }
}

class NewConnectionUseCaseParams extends BaseParams {
  final Connection? connection;

  NewConnectionUseCaseParams({this.connection});

  @override
  List<Object?> get props => [connection];
}
