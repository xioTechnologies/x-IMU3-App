import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/commands/domain/usecases/write_command_usecase.dart';
import 'package:ximu3_app/features/commands/presentation/bloc/command_state.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../connections/data/model/connection.dart';
import '../../data/model/command_message.dart';

class CommandCubit extends Cubit<CommandState> {
  final WriteCommandUseCase sendCommandUseCase;

  CommandCubit({
    required this.sendCommandUseCase,
  }) : super(CommandInitialState());

  final prefs = injector<SharedPreferencesAbstract>();

  void sendCommand({
    required String key,
    required dynamic value,
    required List<Connection> connections,
  }) async {
    emit(CommandSendingState());

    final failOrSuccess = await sendCommandUseCase.call(
      WriteCommandUseCaseParams(
        command: CommandMessage(
          key: key,
          value: value,
        ),
        connections: connections,
      ),
    );

    if (isClosed) return;

    failOrSuccess.fold(
      (failure) {
        emit(CommandSendErrorState(failure.message));
      },
      (data) {
        emit(CommandSendSuccessState());
      },
    );
  }

  addToRecentNotes(String note) async {
    List<String> recentNotes = getRecentNotes();
    recentNotes.remove(note);
    recentNotes = recentNotes.sublist(0, min(12, recentNotes.length));
    recentNotes = [note] + recentNotes;
    await prefs.setStringList("recentNotes", recentNotes);
  }

  List<String> getRecentNotes() {
    return prefs.getStringList("recentNotes") ?? [];
  }
}
