import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as filter;
import 'package:ximu3_app/core/routes/app_router.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit_extension.dart';
import 'package:ximu3_app/features/graphs/data/model/graph.dart';
import 'package:ximu3_app/features/graphs/presentation/bloc/graph_cubit.dart';
import 'package:ximu3_app/features/graphs/presentation/bloc/graph_state.dart';
import 'package:ximu3_app/features/graphs/presentation/widgets/graph_widget.dart';
import 'package:ximu3_app/features/graphs/utils/graph_service.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../utils/graph_utils.dart';

class ProcessedData {
  final Map<String, List<FlSpot>> spots;
  final double minY;
  final double maxY;

  ProcessedData({required this.spots, required this.minY, required this.maxY});
}

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  List<Graph> graphs = List.from(GraphUtils.allGraphs);
  GraphDataService graphDataService = GraphDataService.instance;

  void _toggleGraphCallback(Graph graph, ConnectionCubit connectionCubit) {
    if (graph.isVisible == true) {
      connectionCubit.addCallbackByGraphTitle(graph.title);
    } else {
      connectionCubit.removeCallbackByGraphTitle(graph.title);
    }
  }

  bool isGraphVisible(String title) {
    return graphs.firstWhereOrNull((g) => g.title == title && g.isVisible) != null;
  }

  void _addCallbacks(ConnectionCubit connectionCubit) {
    if (connectionCubit.activeConnections.isEmpty) {
      return;
    }

    final selectedConnection = connectionCubit.selectedConnection;
    if (selectedConnection == null) {
      return;
    }

    var combinedGraphCallbacks = {
      [Strings.gyroscope, Strings.accelerometer]: selectedConnection.addInertialCallback,
      [Strings.batteryPercentage, Strings.batteryVoltage]: selectedConnection.addBatteryCallback,
      [Strings.rssiPercentage, Strings.rssiPower]: selectedConnection.addRssiCallback,
      [Strings.receivedDataRate, Strings.receivedMessageRate]:
          selectedConnection.addStatisticsCallback,
    };

    combinedGraphCallbacks.forEach((titles, callback) {
      if (titles.any(isGraphVisible)) {
        callback();
      }
    });

    var singleGraphCallbacks = {
      Strings.magnetometer: selectedConnection.addMagnetometerCallback,
      Strings.highGAccelerometer: selectedConnection.addHighGAccelerometerCallback,
      Strings.temperatureTitle: selectedConnection.addTemperatureCallback,
      Strings.eulerAngles: selectedConnection.addEulerAnglesCallback,
      Strings.earthAccelerometer: selectedConnection.addEarthAccelerationCallback,
      Strings.linearAccelerometer: selectedConnection.addLinearAccelerationCallback,
      Strings.serialAccessoryCsvs: selectedConnection.addSerialAccessoryCallback,
      Strings.quaternion: selectedConnection.addQuaternionCallback,
      Strings.rotationMatrix: selectedConnection.addRotationMatrixCallback,
    };

    singleGraphCallbacks.forEach((title, callback) {
      if (isGraphVisible(title)) {
        callback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GraphCubit>(
      create: (BuildContext context) => GraphCubit(
        context.read<ConnectionCubit>(),
      ),
      child: BlocBuilder<GraphCubit, GraphState>(
        builder: (context, state) {
          var connectionCubit = context.read<ConnectionCubit>();
          _addCallbacks(connectionCubit);

          return Scaffold(
            backgroundColor: Palette.backgroundLight,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Palette.white,
              onPressed: () {
                context.router.push(
                  GraphLayoutRoute(
                    toggleGraph: (graph) {
                      setState(() {
                        _toggleGraphCallback(graph, connectionCubit);
                      });
                    },
                    graphs: graphs,
                  ),
                );
              },
              child: Image.asset(Images.toggle, width: 30),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDeviceListHeader(
                  connectionSelected: (connection) {
                    var connectionCallbacksToRemove = connectionCubit.activeConnections
                        .where((active) => active.connectionInfo != connection?.connectionInfo)
                        .toList();

                    context.read<GraphCubit>().removeCallbacks(connectionCallbacksToRemove);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: graphs
                          .filter((graph) => graph.isVisible == true)
                          .map(
                            (graph) => StreamBuilder<dynamic>(
                              stream: connectionCubit.getActiveConnectionGraphStream(graph),
                              builder: (context, stream) {
                                return Padding(
                                  padding: const EdgeInsets.all(Constants.padding),
                                  child: GraphWidget(
                                    data:
                                        graphDataService.createChartData(stream.data ?? [], graph),
                                    graph: graph,
                                    connectionCubit: connectionCubit,
                                    isFullScreen: false,
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
