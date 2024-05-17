import 'package:equatable/equatable.dart';

import '../../data/model/session.model.dart';

abstract class DataLoggerState extends Equatable {}

class DataLoggerInitialState extends DataLoggerState {
  DataLoggerInitialState();

  @override
  List<Object> get props => [];
}

class CreatingSessionState extends DataLoggerState {
  CreatingSessionState();

  @override
  List<Object> get props => [];
}

class CreateSessionErrorState extends DataLoggerState {
  final String message;

  CreateSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CreateSessionSuccessState extends DataLoggerState {
  CreateSessionSuccessState();

  @override
  List<Object> get props => [];
}

class FetchingSessionsState extends DataLoggerState {
  FetchingSessionsState();

  @override
  List<Object> get props => [];
}

class FetchSessionsErrorState extends DataLoggerState {
  final String message;

  FetchSessionsErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class FetchSessionsSuccessState extends DataLoggerState {
  List<Session> sessions;

  FetchSessionsSuccessState(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class DeletingSessionState extends DataLoggerState {
  DeletingSessionState();

  @override
  List<Object> get props => [];
}

class DeleteSessionErrorState extends DataLoggerState {
  final String message;

  DeleteSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteSessionSuccessState extends DataLoggerState {
  DeleteSessionSuccessState();

  @override
  List<Object> get props => [];
}

class StoppingSessionState extends DataLoggerState {
  StoppingSessionState();

  @override
  List<Object> get props => [];
}

class StopSessionErrorState extends DataLoggerState {
  final String message;

  StopSessionErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class StopSessionSuccessState extends DataLoggerState {
  StopSessionSuccessState();

  @override
  List<Object> get props => [];
}
