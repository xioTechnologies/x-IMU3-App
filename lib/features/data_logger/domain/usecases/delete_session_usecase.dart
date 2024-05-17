import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/data_logger/domain/repository/data_logger_repository.dart';

import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';

class DeleteSessionUseCase {
  DataLoggerRepository repository;

  DeleteSessionUseCase(this.repository);

  Future<Either<Failure, bool>> call(DeleteSessionUseCaseParams params) async {
    return await repository.deleteSession(params);
  }
}

class DeleteSessionUseCaseParams extends BaseParams {
  final String sessionName;

  DeleteSessionUseCaseParams({
    required this.sessionName,
  });

  @override
  List<Object?> get props => [sessionName];
}
