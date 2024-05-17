import 'package:fl_chart/fl_chart.dart';
import 'package:ximu3_app/core/utils/strings.dart';

import '../../../core/utils/palette.dart';
import '../data/model/graph.dart';

class GraphUtils {
  static List<Graph> allGraphs = [
    Graph(
      title: Strings.gyroscope,
      yAxis: Strings.angularRate,
      category: Strings.sensors,
      isVisible: true,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.accelerometer,
      yAxis: Strings.acceleration,
      category: Strings.sensors,
      isVisible: true,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.magnetometer,
      yAxis: Strings.intensity,
      category: Strings.sensors,
      isVisible: false,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.highGAccelerometer,
      yAxis: Strings.acceleration,
      category: Strings.sensors,
      isVisible: false,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.eulerAngles,
      yAxis: Strings.angle,
      category: Strings.ahrs,
      isVisible: true,
      labels: [Strings.roll, Strings.pitch, Strings.yaw],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.linearAccelerometer,
      yAxis: Strings.acceleration,
      category: Strings.ahrs,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.earthAccelerometer,
      yAxis: Strings.acceleration,
      category: Strings.ahrs,
      labels: [Strings.x, Strings.y, Strings.z],
      colors: [Palette.graphX, Palette.graphY, Palette.graphZ],
    ),
    Graph(
      title: Strings.serialAccessoryCsvs,
      yAxis: Strings.csv,
      category: Strings.serialAccessory,
      labels: ["1", "2", "3", "4", "5", "6", "7", "8"],
      colors: [
        Palette.graphChannel1,
        Palette.graphChannel2,
        Palette.graphChannel3,
        Palette.graphChannel4,
        Palette.graphChannel5,
        Palette.graphChannel6,
        Palette.graphChannel7,
        Palette.graphChannel8
      ],
    ),
    Graph(
      title: Strings.temperatureTitle,
      yAxis: Strings.temperatureC,
      singleLine: true,
      category: Strings.status,
      labels: [Strings.temperatureC],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.batteryPercentage,
      yAxis: Strings.percentage,
      singleLine: true,
      category: Strings.status,
      labels: [Strings.percentage],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.batteryVoltage,
      yAxis: Strings.voltage,
      singleLine: true,
      category: Strings.status,
      labels: [Strings.voltage],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.rssiPercentage,
      yAxis: Strings.percentage,
      singleLine: true,
      category: Strings.status,
      labels: [Strings.percentage],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.rssiPower,
      yAxis: Strings.power,
      singleLine: true,
      category: Strings.status,
      labels: [Strings.rssiPower],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.receivedMessageRate,
      yAxis: Strings.throughputMessages,
      singleLine: true,
      category: Strings.connection,
      labels: [Strings.throughputMessages],
      colors: [Palette.graphChannel1],
    ),
    Graph(
      title: Strings.receivedDataRate,
      yAxis: Strings.throughputKB,
      singleLine: true,
      category: Strings.connection,
      labels: [Strings.receivedDataRate],
      colors: [Palette.graphChannel1],
    ),
  ];

  static double getWidth(double maxYValue) {
    double width;

    if (maxYValue <= 100) {
      width = 30;
    } else if (maxYValue <= 1000) {
      width = 40;
    } else {
      width = 50;
    }
    return width;
  }

  static FlLine getGridLine() {
    return FlLine(
      color: Palette.unselected,
      strokeWidth: 0.1,
    );
  }
}
