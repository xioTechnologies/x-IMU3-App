import 'package:equatable/equatable.dart';

/// Base class for all types of failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class DefaultFailure extends Failure {
  const DefaultFailure(String message) : super(message);
}
