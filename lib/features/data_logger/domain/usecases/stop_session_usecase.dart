import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/data_logger/domain/repository/data_logger_repository.dart';

import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';

class StopSessionUseCase {
  DataLoggerRepository repository;

  StopSessionUseCase(this.repository);

  Future<Either<Failure, bool>> call(StopSessionUseCaseParams params) async {
    return await repository.stopSession(params);
  }
}

class StopSessionUseCaseParams extends BaseParams {
  final String sessionName;

  StopSessionUseCaseParams({
    required this.sessionName,
  });

  @override
  List<Object?> get props => [sessionName];
}
