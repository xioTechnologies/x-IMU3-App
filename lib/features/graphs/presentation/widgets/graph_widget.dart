import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../../connections/presentation/bloc/connection_cubit.dart';
import '../../data/model/graph.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({
    super.key,
    required this.data,
    required this.graph,
    required this.connectionCubit,
    required this.isFullScreen,
  });

  final LineChartData? data;
  final Graph graph;
  final ConnectionCubit connectionCubit;
  final bool isFullScreen;

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  _legendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widget.graph.labels
          .asMap()
          .map(
            (i, element) => MapEntry(
              i,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: AppText(
                  text: element,
                  weight: Weight.regular,
                  size: SizeFont.M,
                  align: TextAlign.right,
                  color: widget.graph.colors[i],
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.isFullScreen) {
                          context.router.popForced();
                        } else {
                          AppGraphFullScreen.show(
                            context: context,
                            graph: widget.graph,
                            buttonTitles: [],
                            data: widget.data,
                            buttonTap: (index) {},
                            connectionCubit: widget.connectionCubit,
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        widget.isFullScreen ? Images.exitFullscreen : Images.fullScreen,
                      ),
                    ),
                    const SizedBox(width: Constants.padding),
                    AppText(
                      text: widget.graph.title,
                      weight: Weight.medium,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (!widget.graph.singleLine) _legendWidget(),
            ],
          ),
          const SizedBox(height: Constants.padding),
          IgnorePointer(
            child: SizedBox(
              height: widget.isFullScreen ? (MediaQuery.of(context).size.height * 0.75) : 250,
              child: Padding(
                padding: const EdgeInsets.only(top: Constants.padding),
                child: widget.data == null
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.unselected, width: 0),
                        ),
                        child: const Center(
                          child: AppText(text: Strings.noData, color: Palette.unselected),
                        ),
                      )
                    : LineChart(widget.data!, duration: Duration.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
