import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/core/widgets/app_snack.dart';
import 'package:ximu3_app/main.dart';
import 'package:collection/collection.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../../core/usecase/failures.dart';
import '../../data/datasource/commands_datasource.dart';
import '../../data/model/command_message.dart';
import '../usecases/read_command_usecase.dart';
import '../usecases/write_command_usecase.dart';

abstract class CommandRepository {
  Future<Either<Failure, bool>> writeCommand(WriteCommandUseCaseParams params);

  Future<Either<Failure, List<CommandMessage>>> readCommands(ReadCommandsUseCaseParams params);
}

class CommandRepositoryImpl extends CommandRepository {
  CommandsAPI api = CommandsAPI.instance;
  final prefs = injector<SharedPreferencesAbstract>();

  CommandRepositoryImpl();

  @override
  Future<Either<Failure, bool>> writeCommand(WriteCommandUseCaseParams params) async {
    try {
      bool confirmed = true;

      for (var connection in params.connections) {
        if (connection.connectionPointer == null) {
          continue;
        }

        final List<CommandMessage> responses = await CommandsAPI.sendCommandAsync([params.command], connection.connectionPointer!);
        if (responses.isEmpty || responses[0].key != params.command.key || responses[0].getError() != null) {
          confirmed = false;
          continue;
        }
      }

      if (globalBuildContext.mounted) {
        AppSnack.show(globalBuildContext, message: "Command ${params.command.toJson()} ${confirmed ? 'confirmed' : 'failed'}");
      }

      return const Right(true);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, List<CommandMessage>>> readCommands(ReadCommandsUseCaseParams params) async {
    try {
      List<CommandMessage> result = [];

      if (params.connection.connectionPointer == null) {
        return Right(result);
      }

      List<CommandMessage> commands = [];
      for (String key in params.keys) {
        commands.add(CommandMessage(key: key, value: null));
      }

      List<CommandMessage> responses = await CommandsAPI.sendCommandAsync(commands, params.connection.connectionPointer!);

      bool confirmed = true;

      for (final CommandMessage command in commands) {
        CommandMessage? response = responses.firstWhereOrNull((response) => response.key == command.key);
        if (response == null || response!.getError() != null) {
          confirmed = false;
          continue;
        }

        result.add(response);
      }

      if (globalBuildContext.mounted && !confirmed) {
        AppSnack.show(globalBuildContext, message: "Failed to confirm one or more commands");
      }

      return Right(result);
    } catch (error) {
      return Left(DefaultFailure("$error"));
    }
  }
}
