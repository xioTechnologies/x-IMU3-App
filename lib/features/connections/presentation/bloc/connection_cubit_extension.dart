import '../../../../core/utils/strings.dart';
import '../../../graphs/utils/graph_utils.dart';
import '../../data/model/callback.dart';
import '../../data/model/connection.dart';
import 'connection_cubit.dart';

extension ConnectionCubitExtensions on ConnectionCubit {
  void addCallbackByGraphTitle(String title) {
    final Map<String, Function> callbacks = {
      Strings.receivedMessageRate: (Connection connection) =>
          addSharedCallback(connection.statisticsCallback, title),
      Strings.receivedDataRate: (Connection connection) =>
          addSharedCallback(connection.statisticsCallback, title),
      Strings.gyroscope: (Connection connection) =>
          addSharedCallback(connection.inertialCallback, title),
      Strings.accelerometer: (Connection connection) =>
          addSharedCallback(connection.inertialCallback, title),
      Strings.magnetometer: (Connection connection) =>
          addSharedCallback(connection.magnetometerCallback, title),
      Strings.quaternion: (Connection connection) =>
          addSharedCallback(connection.quaternionCallback, title),
      Strings.rotationMatrix: (Connection connection) =>
          addSharedCallback(connection.rotationMatrixCallback, title),
      Strings.eulerAngles: (Connection connection) =>
          addSharedCallback(connection.eulerAnglesCallback, title),
      Strings.linearAccelerometer: (Connection connection) =>
          addSharedCallback(connection.linearAccelerationCallback, title),
      Strings.earthAccelerometer: (Connection connection) =>
          addSharedCallback(connection.earthAccelerationCallback, title),
      Strings.highGAccelerometer: (Connection connection) =>
          addSharedCallback(connection.highGAccelerometerCallback, title),
      Strings.temperatureTitle: (Connection connection) =>
          addSharedCallback(connection.temperatureCallback, title),
      Strings.batteryPercentage: (Connection connection) =>
          addSharedCallback(connection.batteryCallback, title),
      Strings.batteryVoltage: (Connection connection) =>
          addSharedCallback(connection.batteryCallback, title),
      Strings.rssiPercentage: (Connection connection) =>
          addSharedCallback(connection.rssiCallback, title),
      Strings.rssiPower: (Connection connection) =>
          addSharedCallback(connection.rssiCallback, title),
      Strings.serialAccessoryCsvs: (Connection connection) =>
          addSharedCallback(connection.serialAccessoryCallback, title),
    };

    for (var connection in activeConnections) {
      callbacks[title]?.call(connection);
    }
  }

  void addSharedCallback(Callback? callback, String title) {
    if (callback == null || callback.keys.isEmpty) return;

    if (callback.keys.length == 1) {
      _getCallbackAddFunction(title)?.call();
    } else {
      bool shouldAddCallback = false;

      for (var key in callback.keys) {
        var graph = GraphUtils.allGraphs.firstWhere((g) => g.title == key);

        if (graph.isVisible == true && graph.title != title) {
          shouldAddCallback = false;
        } else {
          shouldAddCallback = true;
        }
      }

      if (shouldAddCallback) {
        _getCallbackAddFunction(title)?.call();
      }
    }
  }

  Function? _getCallbackAddFunction(String title) {
    final Map<String, Function?> callbacks = {
      Strings.receivedMessageRate: selectedConnection?.addStatisticsCallback,
      Strings.receivedDataRate: selectedConnection?.addStatisticsCallback,
      Strings.gyroscope: selectedConnection?.addInertialCallback,
      Strings.accelerometer: selectedConnection?.addInertialCallback,
      Strings.magnetometer: selectedConnection?.addMagnetometerCallback,
      Strings.quaternion: selectedConnection?.addQuaternionCallback,
      Strings.rotationMatrix: selectedConnection?.addRotationMatrixCallback,
      Strings.eulerAngles: selectedConnection?.addEulerAnglesCallback,
      Strings.linearAccelerometer: selectedConnection?.addLinearAccelerationCallback,
      Strings.earthAccelerometer: selectedConnection?.addEarthAccelerationCallback,
      Strings.highGAccelerometer: selectedConnection?.addHighGAccelerometerCallback,
      Strings.temperatureTitle: selectedConnection?.addTemperatureCallback,
      Strings.batteryPercentage: selectedConnection?.addBatteryCallback,
      Strings.batteryVoltage: selectedConnection?.addBatteryCallback,
      Strings.rssiPercentage: selectedConnection?.addRssiCallback,
      Strings.rssiPower: selectedConnection?.addRssiCallback,
      Strings.serialAccessoryCsvs: selectedConnection?.addSerialAccessoryCallback,
    };

    return callbacks[title];
  }

  void removeCallbackByGraphTitle(String title) {
    final Map<String, Function> callbackRemovers = {
      Strings.receivedMessageRate: (Connection connection) =>
          removeSharedCallback(connection.statisticsCallback),
      Strings.receivedDataRate: (Connection connection) =>
          removeSharedCallback(connection.statisticsCallback),
      Strings.gyroscope: (Connection connection) =>
          removeSharedCallback(connection.inertialCallback),
      Strings.accelerometer: (Connection connection) =>
          removeSharedCallback(connection.inertialCallback),
      Strings.magnetometer: (Connection connection) =>
          removeSharedCallback(connection.magnetometerCallback),
      Strings.quaternion: (Connection connection) =>
          removeSharedCallback(connection.quaternionCallback),
      Strings.rotationMatrix: (Connection connection) =>
          removeSharedCallback(connection.rotationMatrixCallback),
      Strings.eulerAngles: (Connection connection) =>
          removeSharedCallback(connection.eulerAnglesCallback),
      Strings.linearAccelerometer: (Connection connection) =>
          removeSharedCallback(connection.linearAccelerationCallback),
      Strings.earthAccelerometer: (Connection connection) =>
          removeSharedCallback(connection.earthAccelerationCallback),
      Strings.highGAccelerometer: (Connection connection) =>
          removeSharedCallback(connection.highGAccelerometerCallback),
      Strings.temperatureTitle: (Connection connection) =>
          removeSharedCallback(connection.temperatureCallback),
      Strings.batteryPercentage: (Connection connection) =>
          removeSharedCallback(connection.batteryCallback),
      Strings.batteryVoltage: (Connection connection) =>
          removeSharedCallback(connection.batteryCallback),
      Strings.rssiPercentage: (Connection connection) =>
          removeSharedCallback(connection.rssiCallback),
      Strings.rssiPower: (Connection connection) => removeSharedCallback(connection.rssiCallback),
      Strings.serialAccessoryCsvs: (Connection connection) =>
          removeSharedCallback(connection.serialAccessoryCallback),
    };

    for (var connection in activeConnections) {
      callbackRemovers[title]?.call(connection);
    }
  }

  void removeSharedCallback(Callback? callback) {
    if (callback == null || callback.keys.isEmpty) return;

    bool allRelatedGraphsHidden = callback.keys.every(
      (title) => !GraphUtils.allGraphs.any(
        (graph) => graph.title == title && graph.isVisible,
      ),
    );

    if (allRelatedGraphsHidden) {
      for (var connection in activeConnections) {
        removeCallback(callback, connection);
      }
    }
  }
}
