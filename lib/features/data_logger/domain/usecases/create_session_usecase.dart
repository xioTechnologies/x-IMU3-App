import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/data_logger/domain/repository/data_logger_repository.dart';

import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../../../connections/data/model/connection.dart';

class CreateSessionUseCase {
  DataLoggerRepository repository;

  CreateSessionUseCase(this.repository);

  Future<Either<Failure, bool>> call(CreateSessionUseCaseParams params) async {
    return await repository.createSession(params);
  }
}

class CreateSessionUseCaseParams extends BaseParams {
  final String sessionName;
  final List<Connection> connections;

  CreateSessionUseCaseParams({
    required this.connections,
    required this.sessionName,
  });

  @override
  List<Object?> get props => [sessionName, connections];
}
