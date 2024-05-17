import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/connections/presentation/bloc/connection_cubit.dart';
import '../../features/graphs/data/model/graph.dart';
import '../../features/graphs/presentation/widgets/graph_widget.dart';
import '../../features/graphs/utils/graph_service.dart';
import '../utils/index.dart';

class AppGraphFullScreen {
  static show({
    required BuildContext context,
    required Graph graph,
    required List<String> buttonTitles,
    required LineChartData? data,
    required Function(int) buttonTap,
    required ConnectionCubit connectionCubit,
  }) {
    GraphDataService graphDataService = GraphDataService.instance;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    Color backgroundColor() => Palette.backgroundLight;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: backgroundColor(),
      builder: (BuildContext ctx) {
        final Size screenSize = MediaQuery.of(ctx).size;

        return Dialog(
          surfaceTintColor: backgroundColor(),
          insetPadding: EdgeInsets.zero,
          backgroundColor: backgroundColor(),
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: StreamBuilder<dynamic>(
              stream: connectionCubit.getActiveConnectionGraphStream(graph),
              builder: (context, stream) {
                return Padding(
                  padding: const EdgeInsets.all(Constants.padding),
                  child: GraphWidget(
                    data: graphDataService.createChartData(stream.data ?? [], graph),
                    graph: graph,
                    connectionCubit: connectionCubit,
                    isFullScreen: true,
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }
}
