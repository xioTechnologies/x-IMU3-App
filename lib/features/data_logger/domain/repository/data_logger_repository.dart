import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/data_logger/data/datasource/data_logger_datasource.dart';
import 'package:ximu3_app/features/data_logger/data/model/session.model.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/stop_session_usecase.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../../core/usecase/failures.dart';
import '../usecases/create_session_usecase.dart';
import '../usecases/delete_session_usecase.dart';

abstract class DataLoggerRepository {
  Future<Either<Failure, bool>> createSession(CreateSessionUseCaseParams params);
  Future<Either<Failure, bool>> stopSession(StopSessionUseCaseParams params);
  Future<Either<Failure, bool>> deleteSession(DeleteSessionUseCaseParams params);
  Future<Either<Failure, List<Session>>> getSessions();
}

class DataLoggerRepositoryImpl extends DataLoggerRepository {
  DataLoggerAPI api = DataLoggerAPI.instance;

  final prefs = injector<SharedPreferencesAbstract>();

  @override
  Future<Either<Failure, bool>> createSession(CreateSessionUseCaseParams params) async {
    try {
      final data = await api.openSession(params.sessionName, params.connections);
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, bool>> stopSession(StopSessionUseCaseParams params) async {
    try {
      final data = await api.stopSession(params.sessionName);
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSession(DeleteSessionUseCaseParams params) async {
    try {
      final data = await api.deleteSessionZip(params.sessionName);
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getSessions() async {
    try {
      final data = await api.getSessions();
      return Right(data);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }
}
