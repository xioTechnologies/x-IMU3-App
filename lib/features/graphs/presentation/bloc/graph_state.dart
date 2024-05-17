import 'package:equatable/equatable.dart';

abstract class GraphState extends Equatable {}

class GraphInitialState extends GraphState {
  GraphInitialState();

  @override
  List<Object> get props => [];
}
