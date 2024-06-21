import 'package:ximu3_app/features/commands/data/model/command_message.dart';
import 'package:ximu3_app/features/commands/domain/repository/command_respository.dart';

import '../../../../core/usecase/usecase_params.dart';
import '../../../connections/data/model/connection.dart';

class SendCommandsUseCase {
  CommandRepository repository;

  SendCommandsUseCase(this.repository);

  Future<List<CommandMessage>> call(SendCommandsUseCaseParams params) {
    return repository.sendCommands(params);
  }
}

class SendCommandsUseCaseParams extends BaseParams {
  final List<CommandMessage> commands;
  final Connection connection;

  SendCommandsUseCaseParams({
    required this.commands,
    required this.connection,
  });

  @override
  List<Object?> get props => [commands, connection];
}
