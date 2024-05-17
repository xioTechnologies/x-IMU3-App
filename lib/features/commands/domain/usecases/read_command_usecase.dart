import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/commands/domain/repository/command_respository.dart';
import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../../../connections/data/model/connection.dart';
import '../../data/model/command_message.dart';

class ReadCommandsUseCase {
  CommandRepository repository;

  ReadCommandsUseCase(this.repository);

  Future<Either<Failure, List<CommandMessage>>> call(ReadCommandsUseCaseParams params) async {
    return await repository.readCommands(params);
  }
}

class ReadCommandsUseCaseParams extends BaseParams {
  final List<String> keys;
  final Connection connection;

  ReadCommandsUseCaseParams({
    required this.keys,
    required this.connection,
  });

  @override
  List<Object?> get props => [keys, connection];
}
