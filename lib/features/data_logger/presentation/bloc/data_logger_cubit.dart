import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/create_session_usecase.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/delete_session_usecase.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_state.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../../core/utils/strings.dart';
import '../../../connections/data/model/connection.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../../domain/usecases/stop_session_usecase.dart';

class DataLoggerCubit extends Cubit<DataLoggerState> {
  final CreateSessionUseCase createSessionUseCase;
  final StopSessionUseCase stopSessionUseCase;
  final DeleteSessionUseCase deleteSessionUseCase;
  final GetSessionsUseCase getSessionsUseCase;

  ValueNotifier<bool> recordingNotifier = ValueNotifier(false);

  final prefs = injector<SharedPreferencesAbstract>();

  Timer? timer;
  late ValueNotifier<String> timerNotifier = ValueNotifier(Strings.stopwatchPlaceholder);

  String sessionName = "";

  DataLoggerCubit({
    required this.createSessionUseCase,
    required this.stopSessionUseCase,
    required this.deleteSessionUseCase,
    required this.getSessionsUseCase,
  }) : super(DataLoggerInitialState());

  Future<void> createSession({
    required List<Connection> connections,
  }) async {
    emit(CreatingSessionState());

    final failOrSuccess = await createSessionUseCase.call(
      CreateSessionUseCaseParams(
        sessionName: sessionName,
        connections: connections,
      ),
    );

    failOrSuccess.fold(
      (failure) {
        emit(CreateSessionErrorState(failure.message));
      },
      (data) {
        emit(CreateSessionSuccessState());

        recordingNotifier.value = true;
      },
    );
  }

  Future<void> stopSession() async {
    emit(StoppingSessionState());

    final failOrSuccess = await stopSessionUseCase.call(
      StopSessionUseCaseParams(sessionName: sessionName),
    );

    failOrSuccess.fold(
      (failure) {
        emit(StopSessionErrorState(failure.message));
      },
      (data) {
        emit(StopSessionSuccessState());

        timer?.cancel();
        recordingNotifier.value = false;
      },
    );
  }

  Future<void> deleteSession({required String name}) async {
    emit(DeletingSessionState());

    final failOrSuccess = await deleteSessionUseCase.call(
      DeleteSessionUseCaseParams(sessionName: name),
    );

    failOrSuccess.fold(
      (failure) {
        emit(DeleteSessionErrorState(failure.message));
      },
      (data) {
        emit(DeleteSessionSuccessState());
      },
    );
  }

  Future<void> getSessions() async {
    emit(FetchingSessionsState());

    final failOrSuccess = await getSessionsUseCase.call();

    failOrSuccess.fold(
      (failure) {
        emit(FetchSessionsErrorState(failure.message));
      },
      (data) {
        emit(FetchSessionsSuccessState(data));
      },
    );
  }
}
