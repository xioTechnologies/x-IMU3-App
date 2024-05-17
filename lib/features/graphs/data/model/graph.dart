import 'dart:ui';

class Graph {
  String title;
  String yAxis;
  bool singleLine;
  bool isVisible;
  String category;
  List<String> labels;
  List<Color> colors;

  Graph({
    required this.title,
    required this.yAxis,
    required this.category,
    required this.labels,
    required this.colors,
    this.isVisible = false,
    this.singleLine = false,
  });
}
