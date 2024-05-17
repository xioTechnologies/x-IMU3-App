import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/graphs/presentation/bloc/graph_state.dart';

import '../../../connections/data/model/connection.dart';
import '../../../connections/presentation/bloc/connection_cubit.dart';

class GraphCubit extends Cubit<GraphState> {
  final ConnectionCubit connectionCubit;

  GraphCubit(this.connectionCubit) : super(GraphInitialState());

  @override
  Future<void> close() {
    removeCallbacks(connectionCubit.activeConnections);
    return super.close();
  }

  void removeCallbacks(List<Connection> connections) {
    connectionCubit.removeCallbacks(connections);
  }
}
