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

class CommandSentState extends CommandState {
  CommandSentState();

  @override
  List<Object> get props => [];
}
