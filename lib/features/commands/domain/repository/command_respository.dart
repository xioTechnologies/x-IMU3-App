import 'package:ximu3_app/core/widgets/app_snack.dart';
import 'package:ximu3_app/main.dart';
import 'package:collection/collection.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../data/datasource/commands_datasource.dart';
import '../../data/model/command_message.dart';
import '../usecases/send_commands_usecase.dart';

abstract class CommandRepository {
  Future<List<CommandMessage>> sendCommands(SendCommandsUseCaseParams params);
}

class CommandRepositoryImpl extends CommandRepository {
  CommandsAPI api = CommandsAPI.instance;
  final prefs = injector<SharedPreferencesAbstract>();

  CommandRepositoryImpl();

  @override
  Future<List<CommandMessage>> sendCommands(SendCommandsUseCaseParams params) async {
    if (params.connection.connectionPointer == null) {
      return [];
    }

    List<CommandMessage> failedCommands = [];

    final List<CommandMessage> responses = await CommandsAPI.sendCommandsAsync(params.commands, params.connection.connectionPointer!);

    for (final command in params.commands) {
      CommandMessage? response = responses.firstWhereOrNull((response) => command.key == response.key);
      if (response == null || response.error != null) {
        failedCommands.add(command);
      }
    }

    if (globalBuildContext.mounted) {
      if (failedCommands.isEmpty) {
        if (params.commands.length == 1) {
          AppSnack.show(globalBuildContext, message: "Command ${params.commands[0].json} confirmed");
        }
      }
      else if (failedCommands.length == 1) {
        AppSnack.show(globalBuildContext, message: "Command ${failedCommands[0].json} failed");
      }
      else {
        AppSnack.show(globalBuildContext, message: "Failed to confirm one or more commands");
      }
    }

    return responses;
  }
}
