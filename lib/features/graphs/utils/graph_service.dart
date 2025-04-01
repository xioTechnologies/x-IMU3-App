import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

import '../../../core/api/ffi_helpers.dart';
import '../../../core/utils/index.dart';
import '../../../core/widgets/index.dart';
import '../data/model/graph.dart';
import 'graph_utils.dart';

class ProcessedData {
  final Map<String, List<FlSpot>> spots;
  final double minY;
  final double maxY;

  ProcessedData({required this.spots, required this.minY, required this.maxY});
}

class GraphDataService {
  static final GraphDataService _instance = GraphDataService._internal();

  static GraphDataService get instance => _instance;

  GraphDataService._internal();

  ProcessedData processSensorData<T>(List<dynamic> data, Graph graph) {
    Map<String, List<FlSpot>> spots = {};

    for (var label in graph.labels) {
      spots[label] = [];
    }

    double minY = double.infinity, maxY = -double.infinity;

    double latestTimestamp = data.isNotEmpty ? (data.last as dynamic).timestamp.toDouble() / 1000000.0 : 0.0;

    for (var datum in data) {
      double timestamp = datum.timestamp.toDouble() / 1000000.0;
      double adjustedTime = timestamp - latestTimestamp;

      List<double> values = [];

      switch (datum.runtimeType) {
        case XIMU3_InertialMessage:
          switch (graph.title) {
            case Strings.gyroscope:
              values = [
                datum.gyroscope_x ?? 0,
                datum.gyroscope_y ?? 0,
                datum.gyroscope_z ?? 0,
              ];

              break;
            case Strings.accelerometer:
            case Strings.linearAccelerometer:
            case Strings.earthAccelerometer:
              values = [
                datum.accelerometer_x ?? 0,
                datum.accelerometer_y ?? 0,
                datum.accelerometer_z ?? 0,
              ];
              break;
          }
        case XIMU3_EulerAnglesMessage:
          values = [
            datum.pitch ?? 0,
            datum.roll ?? 0,
            datum.yaw ?? 0,
          ];
          break;
        case XIMU3_MagnetometerMessage:
        case XIMU3_HighGAccelerometerMessage:
          values = [
            datum == null ? 0 : (datum?.x ?? 0),
            datum == null ? 0 : (datum?.y ?? 0),
            datum == null ? 0 : (datum?.z ?? 0),
          ];
          break;
        case XIMU3_TemperatureMessage:
          values = [datum == null ? 0 : (datum?.temperatureTitle ?? 0)];
          break;
        case XIMU3_RssiMessage:
          switch (graph.title) {
            case Strings.rssiPower:
              values = [datum == null ? 0 : (datum?.power ?? 0)];
              break;
            case Strings.rssiPercentage:
              values = [datum == null ? 0 : (datum?.percentage ?? 0)];
              break;
          }
        case XIMU3_Statistics:
          switch (graph.title) {
            case Strings.receivedMessageRate:
              values = [double.tryParse(datum.message_rate.toString()) ?? 0];
              break;
            case Strings.receivedDataRate:
              values = [double.tryParse(datum.data_rate.toString()) ?? 0];
              break;
          }
        case XIMU3_BatteryMessage:
          switch (graph.title) {
            case Strings.voltage:
              values = [datum.voltage ?? 0];
              break;
            case Strings.batteryPercentage:
              values = [datum.percentage ?? 0];
              break;
          }
        case XIMU3_SerialAccessoryMessage:
          String charArrayString = FFIHelpers.convertCharArrayToString(datum.char_array);
          List<String> stringValues = charArrayString.split(',');
          values = stringValues.map((s) => double.tryParse(s) ?? 0.0).toList();
          break;
      }

      for (var i = 0; i < values.length && i < graph.labels.length; i++) {
        spots[graph.labels[i]]?.add(FlSpot(adjustedTime, values[i]));
      }

      minY = min(minY, values.isEmpty ? 0 : values.reduce(min));
      maxY = max(maxY, values.isEmpty ? 0 : values.reduce(max));
    }

    minY = minY.isFinite ? minY : 0.0;
    maxY = maxY.isFinite ? maxY : 1.0;

    return ProcessedData(spots: spots, minY: minY, maxY: maxY);
  }

  LineChartData buildLineChartData(Map<String, List<FlSpot>> spots, double minX, double maxX, double minY, double maxY, bool singleLine, Graph graph) {
    List<LineChartBarData> lines = graph.labels
        .asMap()
        .map(
          (i, element) => MapEntry(
            i,
            buildLine(spots[element]!, graph.colors[i]),
          ),
        )
        .values
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (line) => GraphUtils.getGridLine(),
        getDrawingVerticalLine: (line) => GraphUtils.getGridLine(),
      ),
      clipData: FlClipData.all(),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameSize: 20.0,
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(left: 60.0),
            child: AppText(
              text: Strings.time,
              color: Palette.white,
              weight: Weight.regular,
              size: SizeFont.xS,
            ),
          ),
          sideTitles: SideTitles(
            reservedSize: 20,
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value % 1 == 0 && value >= minX && value <= maxX) {
                return AppText(
                  text: value.toInt() == 0 ? '0' : '${(value).toInt()}',
                  size: SizeFont.xS,
                  color: Palette.white.withOpacity(Constants.opacity),
                );
              }
              return const AppText(text: '');
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: true,
          axisNameSize: 14.0,
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: AppText(
              text: graph.yAxis,
              color: Palette.white,
              weight: Weight.regular,
              size: SizeFont.xS,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: GraphUtils.getWidth(maxY),
            getTitlesWidget: (value, meta) {
              String text;
              if (value < 1 && value > -1) {
                text = value.toStringAsFixed(value == 0 ? 0 : 1);
              } else {
                text = value.toInt().toString();
              }

              if (value == minY || value == maxY || value == 0) {
                return Container(
                  color: value == 0 ? Colors.transparent : Palette.backgroundLight,
                  padding: const EdgeInsets.only(right: 5),
                  child: AppText(
                    text: text,
                    size: SizeFont.xS,
                    color: Palette.white,
                    align: TextAlign.right,
                  ),
                );
              }
              return Container();
            },
            interval: (maxY - minY) == 0 ? null : maxY - minY,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Palette.unselected, width: 1),
      ),
      lineBarsData: lines,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
    );
  }

  LineChartBarData buildLine(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 1,
      preventCurveOverShooting: true,
      dotData: FlDotData(show: false),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return SideTitleWidget(
      meta: meta,
      space: 8.0,
      child: Text(value.toString(), style: style),
    );
  }

  LineChartData? createChartData(List<dynamic> data, Graph graph) {
    if (data.isEmpty) return null;

    const double minX = -10.0, maxX = 0.0;

    ProcessedData? processedData;

    final processingFunctions = {
      Strings.gyroscope: () => processSensorData<XIMU3_InertialMessage>(data, graph),
      Strings.accelerometer: () => processSensorData<XIMU3_InertialMessage>(data, graph),
      Strings.magnetometer: () => processSensorData<XIMU3_MagnetometerMessage>(data, graph),
      Strings.eulerAngles: () => processSensorData<XIMU3_EulerAnglesMessage>(data, graph),
      Strings.linearAccelerometer: () => processSensorData<XIMU3_LinearAccelerationMessage>(data, graph),
      Strings.earthAccelerometer: () => processSensorData<XIMU3_EarthAccelerationMessage>(data, graph),
      Strings.highGAccelerometer: () => processSensorData<XIMU3_HighGAccelerometerMessage>(data, graph),
      Strings.temperatureTitle: () => processSensorData<XIMU3_TemperatureMessage>(data, graph),
      Strings.batteryPercentage: () => processSensorData<XIMU3_BatteryMessage>(data, graph),
      Strings.batteryVoltage: () => processSensorData<XIMU3_BatteryMessage>(data, graph),
      Strings.rssiPercentage: () => processSensorData<XIMU3_RssiMessage>(data, graph),
      Strings.rssiPower: () => processSensorData<XIMU3_RssiMessage>(data, graph),
      Strings.serialAccessoryCsvs: () => processSensorData<XIMU3_SerialAccessoryMessage>(data, graph),
      Strings.receivedDataRate: () => processSensorData<XIMU3_Statistics>(data, graph),
      Strings.receivedMessageRate: () => processSensorData<XIMU3_Statistics>(data, graph),
    };

    processedData = processingFunctions[graph.title]?.call();

    if (processedData != null) {
      return buildLineChartData(processedData.spots, minX, maxX, processedData.minY, processedData.maxY, graph.singleLine, graph);
    }
    return null;
  }
}
