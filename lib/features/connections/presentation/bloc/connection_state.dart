import 'package:equatable/equatable.dart';

import '../../data/model/connection.dart';

abstract class ConnectionsState extends Equatable {}

class ConnectionDummyState extends ConnectionsState {
  ConnectionDummyState();

  @override
  List<Object> get props => [];
}

class ConnectionInitialState extends ConnectionsState {
  ConnectionInitialState();

  @override
  List<Object> get props => [];
}

class ConnectionsScanningState extends ConnectionsState {
  ConnectionsScanningState();

  @override
  List<Object> get props => [];
}

class ConnectionsScanSuccessState extends ConnectionsState {
  final List<Connection> connections;

  ConnectionsScanSuccessState(this.connections);

  @override
  List<Object> get props => [connections];
}

class ConnectionsScanErrorState extends ConnectionsState {
  final String message;

  ConnectionsScanErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ConnectingState extends ConnectionsState {
  ConnectingState();

  @override
  List<Object> get props => [];
}

class ConnectSuccessState extends ConnectionsState {
  ConnectSuccessState();

  @override
  List<Object> get props => [];
}

class ManualConnectSuccessState extends ConnectionsState {
  final Connection connection;

  ManualConnectSuccessState(this.connection);

  @override
  List<Object> get props => [connection];
}

class ConnectErrorState extends ConnectionsState {
  final String message;

  ConnectErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DisconnectingState extends ConnectionsState {
  DisconnectingState();

  @override
  List<Object> get props => [];
}

class DisconnectSuccessState extends ConnectionsState {
  DisconnectSuccessState();

  @override
  List<Object> get props => [];
}

class DisconnectErrorState extends ConnectionsState {
  final String message;

  DisconnectErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ConnectionCommandSendingState extends ConnectionsState {
  ConnectionCommandSendingState();

  @override
  List<Object> get props => [];
}

class ConnectionCommandSentState extends ConnectionsState {
  ConnectionCommandSentState();

  @override
  List<Object> get props => [];
}
