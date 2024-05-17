import 'package:equatable/equatable.dart';

abstract class CommandState extends Equatable {}

class CommandInitialState extends CommandState {
  CommandInitialState();

  @override
  List<Object> get props => [];
}

class CommandSendingState extends CommandState {
  CommandSendingState();

  @override
  List<Object> get props => [];
}

class CommandSendErrorState extends CommandState {
  final String message;

  CommandSendErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CommandSendSuccessState extends CommandState {
  CommandSendSuccessState();

  @override
  List<Object> get props => [];
}
