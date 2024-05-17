import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/graph.dart';
import '../../utils/graph_utils.dart';

@RoutePage()
class GraphLayoutPage extends StatefulWidget {
  const GraphLayoutPage({
    super.key,
    required this.toggleGraph,
    required this.graphs,
  });

  final Function(Graph) toggleGraph;
  final List<Graph> graphs;

  @override
  State<GraphLayoutPage> createState() => _GraphLayoutPageState();
}

class _GraphLayoutPageState extends State<GraphLayoutPage> {
  late Map<String, List<Graph>> groupedGraphs;

  @override
  void initState() {
    super.initState();
    groupedGraphs = _groupGraphsByCategory(GraphUtils.allGraphs);
  }

  Map<String, List<Graph>> _groupGraphsByCategory(List<Graph> graphs) {
    Map<String, List<Graph>> groups = {};
    for (var graph in graphs) {
      graph.isVisible = graphs.firstWhere((g) => g.title == graph.title).isVisible;
      (groups[graph.category] ??= []).add(graph);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Strings.graphs),
      backgroundColor: Palette.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: ListView.builder(
          itemCount: groupedGraphs.keys.length,
          itemBuilder: (BuildContext context, int index) {
            String category = groupedGraphs.keys.elementAt(index);
            List<Graph> categoryGraphs = groupedGraphs[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Constants.padding),
                  child: AppText(
                    text: category,
                    color: Palette.unselected,
                    weight: Weight.medium,
                  ),
                ),
                ...categoryGraphs.map(
                  (graph) => ListTile(
                    title: AppText(
                      text: graph.title,
                      weight: Weight.medium,
                    ),
                    trailing: CupertinoSwitch(
                      thumbColor: Palette.backgroundDark,
                      trackColor: Palette.unselected,
                      activeColor: Palette.white,
                      value: graph.isVisible ?? false,
                      onChanged: (bool visible) {
                        setState(() {
                          int totalVisibleCount = groupedGraphs.values
                              .expand((graphs) => graphs)
                              .where((g) => g.isVisible == true)
                              .length;

                          if (visible) {
                            if (totalVisibleCount < Constants.graphLimit) {
                              graph.isVisible = true;
                            } else {
                              AppSnack.show(
                                context,
                                message: Strings.maximumGraphsAllowed,
                                duration: 2000,
                              );

                              return;
                            }
                          } else {
                            graph.isVisible = false;
                          }
                        });

                        widget.toggleGraph(graph);
                      },
                    ),
                  ),
                ),
                if (index < groupedGraphs.keys.length - 1)
                  const Divider(
                    height: Constants.padding,
                    thickness: 1,
                    color: Palette.backgroundLightest,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
