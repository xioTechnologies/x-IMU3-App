import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/data_logger/data/model/session.model.dart';
import 'package:ximu3_app/features/data_logger/domain/repository/data_logger_repository.dart';
import '../../../../core/usecase/failures.dart';

class GetSessionsUseCase {
  DataLoggerRepository repository;

  GetSessionsUseCase(this.repository);

  Future<Either<Failure, List<Session>>> call() async {
    return await repository.getSessions();
  }
}
