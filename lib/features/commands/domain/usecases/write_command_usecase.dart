import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/commands/data/model/command_message.dart';
import 'package:ximu3_app/features/commands/domain/repository/command_respository.dart';

import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../../../connections/data/model/connection.dart';

class WriteCommandUseCase {
  CommandRepository repository;

  WriteCommandUseCase(this.repository);

  Future<Either<Failure, bool>> call(WriteCommandUseCaseParams params) {
    return repository.writeCommand(params);
  }
}

class WriteCommandUseCaseParams extends BaseParams {
  final CommandMessage command;
  final List<Connection> connections;

  WriteCommandUseCaseParams({
    required this.command,
    required this.connections,
  });

  @override
  List<Object?> get props => [command, connections];
}
