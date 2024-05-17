import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:ui';

import 'package:ximu3_app/features/connections/data/model/battery_status.dart';
import 'package:ximu3_app/features/connections/data/model/device.dart';
import 'package:ximu3_app/features/connections/data/model/rssi_status.dart';
import 'package:ximu3_app/main.dart';

import '../../../../core/api/base_api.dart';
import '../../../../core/api/ffi_helpers.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import 'callback.dart';
import 'connection_info.dart';

class Connection {
  final DateTime _startTime = DateTime.now();

  Device device;
  ConnectionInfo? connectionInfo;
  Color? color;
  int? connectionType;
  Pointer<XIMU3_Connection>? connectionPointer;

  StreamController<String>? _permanentStatisticsStreamController;
  StreamController<BatteryStatus>? _permanentBatteryStreamController;
  StreamController<RssiStatus>? _permanentRssiStreamController;
  StreamController<String>? _permanentErrorStreamController;

  Callback<XIMU3_Statistics>? statisticsCallback;
  Callback<XIMU3_InertialMessage>? inertialCallback;
  Callback<XIMU3_MagnetometerMessage>? magnetometerCallback;
  Callback<XIMU3_QuaternionMessage>? quaternionCallback;
  Callback<XIMU3_RotationMatrixMessage>? rotationMatrixCallback;
  Callback<XIMU3_EulerAnglesMessage>? eulerAnglesCallback;
  Callback<XIMU3_LinearAccelerationMessage>? linearAccelerationCallback;
  Callback<XIMU3_EarthAccelerationMessage>? earthAccelerationCallback;
  Callback<XIMU3_HighGAccelerometerMessage>? highGAccelerometerCallback;
  Callback<XIMU3_TemperatureMessage>? temperatureCallback;
  Callback<XIMU3_BatteryMessage>? batteryCallback;
  Callback<XIMU3_RssiMessage>? rssiCallback;
  Callback<XIMU3_SerialAccessoryMessage>? serialAccessoryCallback;

  static NativeLibrary get api => API.api;

  Connection({
    required this.device,
    this.connectionType,
    this.connectionInfo,
    this.connectionPointer,
    this.color,
  });

  _processAndSendData<T>(T data) {
    var callback = _getCallbackForDataType<T>();
    if (callback != null && !(callback.streamController.isClosed)) {
      callback.data.add(data);

      var currentMicroseconds = DateTime.now().difference(_startTime).inMicroseconds;

      callback.data.removeWhere((datapoint) {
        var dynamicData = datapoint as dynamic;

        if (dynamicData?.timestamp is int) {
          var ageMicroseconds = currentMicroseconds - dynamicData.timestamp;

          return ageMicroseconds > 30 * 1000000;
        }
        return false;
      });

      callback.streamController.add(List<T>.from(callback.data));
    }
  }

  Callback<T>? _getCallbackForDataType<T>() {
    if (T == XIMU3_Statistics) {
      return statisticsCallback as Callback<T>?;
    }
    if (T == XIMU3_InertialMessage) {
      return inertialCallback as Callback<T>?;
    }
    if (T == XIMU3_MagnetometerMessage) {
      return magnetometerCallback as Callback<T>?;
    }
    if (T == XIMU3_QuaternionMessage) {
      return quaternionCallback as Callback<T>?;
    }
    if (T == XIMU3_RotationMatrixMessage) {
      return rotationMatrixCallback as Callback<T>?;
    }
    if (T == XIMU3_EulerAnglesMessage) {
      return eulerAnglesCallback as Callback<T>?;
    }
    if (T == XIMU3_LinearAccelerationMessage) {
      return linearAccelerationCallback as Callback<T>?;
    }
    if (T == XIMU3_EarthAccelerationMessage) {
      return earthAccelerationCallback as Callback<T>?;
    }
    if (T == XIMU3_HighGAccelerometerMessage) {
      return highGAccelerometerCallback as Callback<T>?;
    }
    if (T == XIMU3_TemperatureMessage) {
      return temperatureCallback as Callback<T>?;
    }
    if (T == XIMU3_BatteryMessage) {
      return batteryCallback as Callback<T>?;
    }
    if (T == XIMU3_RssiMessage) {
      return rssiCallback as Callback<T>?;
    }
    if (T == XIMU3_SerialAccessoryMessage) {
      return serialAccessoryCallback as Callback<T>?;
    }
    return null;
  }

  void printCallbackAdded(String name, int id) {
    print("Add $name callback ID $id for ${connectionInfo?.label}");
  }

  void addPermanentStatisticsCallback() {
    if (connectionPointer == null) {
      return;
    }

    _permanentStatisticsStreamController = StreamController<String>.broadcast();

    int callbackId = api.XIMU3_connection_add_statistics_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_Statistics data,
                  ffi.Pointer<ffi.Void> context)>.listener(permanentStatisticsCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    ); // callback removed when connection destroyed

    printCallbackAdded('Permanent Statistics', callbackId);
  }

  void addPermanentBatteryCallback() {
    if (connectionPointer == null) {
      return;
    }

    _permanentBatteryStreamController = StreamController<BatteryStatus>.broadcast();

    int callbackId = api.XIMU3_connection_add_battery_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_BatteryMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(batteryCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    ); // callback removed when connection destroyed

    printCallbackAdded('Permanent Battery', callbackId);
  }

  void addPermanentRssiCallback() {
    if (connectionPointer == null) {
      return;
    }

    _permanentRssiStreamController = StreamController<RssiStatus>.broadcast();

    int callbackId = api.XIMU3_connection_add_rssi_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_RssiMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(rssiCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    ); // callback removed when connection destroyed

    printCallbackAdded('Permanent RSSI', callbackId);
  }

  void addPermanentErrorCallback() {
    if (connectionPointer == null) {
      return;
    }

    _permanentErrorStreamController = StreamController<String>.broadcast();

    int callbackId = api.XIMU3_connection_add_error_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_ErrorMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(permanentErrorCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    ); // callback removed when connection destroyed

    printCallbackAdded('Permanent Error', callbackId);
  }

  void addStatisticsCallback() {
    if (statisticsCallback?.callbackId != null) {
      statisticsCallback!.data = [];
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_Statistics>>.broadcast();

    var callbackId = api.XIMU3_connection_add_statistics_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_Statistics data,
                  ffi.Pointer<ffi.Void> context)>.listener(statisticsCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Statistics', callbackId);

    statisticsCallback = Callback<XIMU3_Statistics>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.receivedDataRate, Strings.receivedMessageRate],
    );
  }

  void addInertialCallback() {
    if (inertialCallback?.callbackId != null) {
      inertialCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_InertialMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_inertial_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_InertialMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(inertialCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Inertial', callbackId);

    inertialCallback = Callback<XIMU3_InertialMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.accelerometer, Strings.gyroscope],
    );
  }

  void addMagnetometerCallback() {
    if (magnetometerCallback?.callbackId != null) {
      magnetometerCallback!.data = [];

      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_MagnetometerMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_magnetometer_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_MagnetometerMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(magnetometerCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Magnetometer', callbackId);

    magnetometerCallback = Callback<XIMU3_MagnetometerMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.magnetometer],
    );
  }

  void addQuaternionCallback() {
    if (quaternionCallback?.callbackId != null) {
      quaternionCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_QuaternionMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_quaternion_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_QuaternionMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(quaternionCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Quaternion', callbackId);

    quaternionCallback = Callback<XIMU3_QuaternionMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.quaternion],
    );
  }

  void addRotationMatrixCallback() {
    if (rotationMatrixCallback?.callbackId != null) {
      rotationMatrixCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_RotationMatrixMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_rotation_matrix_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_RotationMatrixMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(rotationMatrixCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Rotation Matrix', callbackId);

    rotationMatrixCallback = Callback<XIMU3_RotationMatrixMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.rotationMatrix],
    );
  }

  void addEulerAnglesCallback() {
    if (eulerAnglesCallback?.callbackId != null) {
      eulerAnglesCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_EulerAnglesMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_euler_angles_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_EulerAnglesMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(eulerAnglesCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Euler Angles', callbackId);

    eulerAnglesCallback = Callback<XIMU3_EulerAnglesMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.eulerAngles],
    );
  }

  void addLinearAccelerationCallback() {
    if (linearAccelerationCallback?.callbackId != null) {
      linearAccelerationCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_LinearAccelerationMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_linear_acceleration_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_LinearAccelerationMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(linearAccelerationCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Linear Acceleration', callbackId);

    linearAccelerationCallback = Callback<XIMU3_LinearAccelerationMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.linearAccelerometer],
    );
  }

  void addEarthAccelerationCallback() {
    if (earthAccelerationCallback?.callbackId != null) {
      earthAccelerationCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_EarthAccelerationMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_earth_acceleration_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_EarthAccelerationMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(earthAccelerationCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Earth Acceleration', callbackId);

    earthAccelerationCallback = Callback<XIMU3_EarthAccelerationMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.earthAccelerometer],
    );
  }

  void addHighGAccelerometerCallback() {
    if (highGAccelerometerCallback?.callbackId != null) {
      highGAccelerometerCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_HighGAccelerometerMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_high_g_accelerometer_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_HighGAccelerometerMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(highGAccelerometerCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('High G Accelerometer', callbackId);

    highGAccelerometerCallback = Callback<XIMU3_HighGAccelerometerMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.highGAccelerometer],
    );
  }

  void addTemperatureCallback() {
    if (temperatureCallback?.callbackId != null) {
      temperatureCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_TemperatureMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_temperature_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_TemperatureMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(temperatureCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Temperature', callbackId);

    temperatureCallback = Callback<XIMU3_TemperatureMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.temperatureTitle],
    );
  }

  void addBatteryCallback() {
    if (batteryCallback?.callbackId != null) {
      batteryCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_BatteryMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_battery_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_BatteryMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(permanentBatteryCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Battery', callbackId);

    batteryCallback = Callback<XIMU3_BatteryMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.batteryPercentage, Strings.batteryVoltage],
    );
  }

  void addRssiCallback() {
    if (rssiCallback?.callbackId != null) {
      rssiCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_RssiMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_rssi_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_RssiMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(permanentRssiCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('RSSI', callbackId);

    rssiCallback = Callback<XIMU3_RssiMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.rssiPercentage, Strings.rssiPower],
    );
  }

  void addSerialAccessoryCallback() {
    if (serialAccessoryCallback?.callbackId != null) {
      serialAccessoryCallback!.data = [];
      return;
    }

    if (connectionPointer == null) {
      return;
    }

    var streamController = StreamController<List<XIMU3_SerialAccessoryMessage>>.broadcast();

    var callbackId = api.XIMU3_connection_add_serial_accessory_callback(
      connectionPointer!,
      NativeCallable<
              ffi.Void Function(XIMU3_SerialAccessoryMessage data,
                  ffi.Pointer<ffi.Void> context)>.listener(serialAccessoryCallbackResult)
          .nativeFunction,
      ffi.nullptr,
    );

    printCallbackAdded('Serial Accessory', callbackId);

    serialAccessoryCallback = Callback<XIMU3_SerialAccessoryMessage>(
      callbackId: callbackId,
      streamController: streamController,
      data: [],
      keys: [Strings.serialAccessoryCsvs],
    );
  }

  void permanentStatisticsCallbackResult(XIMU3_Statistics data, ffi.Pointer<ffi.Void> context) {
    if (!(_permanentStatisticsStreamController?.isClosed ?? false)) {
      _permanentStatisticsStreamController?.add(
          "${data.message_rate} message/s (${(data.data_rate / 1000).toStringAsFixed(2)} kB/s)");
    }
  }

  void permanentBatteryCallbackResult(XIMU3_BatteryMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void permanentRssiCallbackResult(XIMU3_RssiMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void permanentErrorCallbackResult(XIMU3_ErrorMessage data, ffi.Pointer<ffi.Void> context) {
    if (!(_permanentErrorStreamController?.isClosed ?? false)) {
      if (globalBuildContext.mounted) {
        AppSnack.show(globalBuildContext,
            message: FFIHelpers.convertCharArrayToString(data.char_array));
      }

      _permanentErrorStreamController?.add(FFIHelpers.convertCharArrayToString(data.char_array));
    }
  }

  void statisticsCallbackResult(XIMU3_Statistics data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void inertialCallbackResult(XIMU3_InertialMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void magnetometerCallbackResult(XIMU3_MagnetometerMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void quaternionCallbackResult(XIMU3_QuaternionMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void rotationMatrixCallbackResult(
      XIMU3_RotationMatrixMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void eulerAnglesCallbackResult(XIMU3_EulerAnglesMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void linearAccelerationCallbackResult(
      XIMU3_LinearAccelerationMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void earthAccelerationCallbackResult(
      XIMU3_EarthAccelerationMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void highGAccelerometerCallbackResult(
      XIMU3_HighGAccelerometerMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void temperatureCallbackResult(XIMU3_TemperatureMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void batteryCallbackResult(XIMU3_BatteryMessage data, ffi.Pointer<ffi.Void> context) {
    if (!(_permanentBatteryStreamController?.isClosed ?? false)) {
      _permanentBatteryStreamController?.add(BatteryStatus.fromXIMU3BatteryMessage(data));
    }
  }

  void rssiCallbackResult(XIMU3_RssiMessage data, ffi.Pointer<ffi.Void> context) {
    var rssiStatus = RssiStatus.fromXIMU3RssiMessage(data);

    if (!(_permanentRssiStreamController?.isClosed ?? false)) {
      _permanentRssiStreamController?.add(rssiStatus);
    }
  }

  void serialAccessoryCallbackResult(
      XIMU3_SerialAccessoryMessage data, ffi.Pointer<ffi.Void> context) {
    _processAndSendData(data);
  }

  void dispose() {
    _permanentStatisticsStreamController?.close();
    _permanentBatteryStreamController?.close();
    _permanentRssiStreamController?.close();
    _permanentErrorStreamController?.close();

    statisticsCallback?.clear();
    inertialCallback?.clear();
    magnetometerCallback?.clear();
    quaternionCallback?.clear();
    rotationMatrixCallback?.clear();
    eulerAnglesCallback?.clear();
    linearAccelerationCallback?.clear();
    earthAccelerationCallback?.clear();
    highGAccelerometerCallback?.clear();
    temperatureCallback?.clear();
    batteryCallback?.clear();
    rssiCallback?.clear();
    serialAccessoryCallback?.clear();
  }

  Stream<String>? get statisticStream => _permanentStatisticsStreamController?.stream;

  Stream<BatteryStatus>? get batteryStatusStream => _permanentBatteryStreamController?.stream;

  Stream<RssiStatus>? get rssiStatusStream => _permanentRssiStreamController?.stream;

  Stream<String>? get errorStream => _permanentErrorStreamController?.stream;

  Stream? get statisticsStream => statisticsCallback?.streamController.stream;

  Stream? get inertialStream => inertialCallback?.streamController.stream;

  Stream? get magnetometerStream => magnetometerCallback?.streamController.stream;

  Stream? get quaternionStream => quaternionCallback?.streamController.stream;

  Stream? get rotationMatrixStream => rotationMatrixCallback?.streamController.stream;

  Stream? get eulerStream => eulerAnglesCallback?.streamController.stream;

  Stream? get linearAccelerometerStream => linearAccelerationCallback?.streamController.stream;

  Stream? get earthAccelerometerStream => earthAccelerationCallback?.streamController.stream;

  Stream? get highGAccelerometerStream => highGAccelerometerCallback?.streamController.stream;

  Stream? get temperatureStream => temperatureCallback?.streamController.stream;

  Stream? get batteryStream => batteryCallback?.streamController.stream;

  Stream? get rssiStream => rssiCallback?.streamController.stream;

  Stream? get serialAccessoryStream => serialAccessoryCallback?.streamController.stream;

  Stream<List<XIMU3_EulerAnglesMessage>> get unifiedEulerAnglesStream {
    StreamController<List<XIMU3_EulerAnglesMessage>> controller = StreamController.broadcast();

    eulerAnglesCallback?.streamController.stream.listen((dataList) {
      if (dataList.isNotEmpty) {
        controller.add(dataList);
      }
    });

    quaternionCallback?.streamController.stream.listen((dataList) {
      var list = dataList
          .map((data) => api.XIMU3_quaternion_message_to_euler_angles_message(data))
          .toList();

      if (list.isNotEmpty) {
        controller.add(list);
      }
    });

    rotationMatrixCallback?.streamController.stream.listen((dataList) {
      var list = dataList
          .map((data) => api.XIMU3_rotation_matrix_message_to_euler_angles_message(data))
          .toList();

      if (list.isNotEmpty) {
        controller.add(list);
      }
    });

    linearAccelerationCallback?.streamController.stream.listen((dataList) {
      var list = dataList
          .map((data) => api.XIMU3_linear_acceleration_message_to_euler_angles_message(data))
          .toList();

      if (list.isNotEmpty) {
        controller.add(list);
      }
    });

    earthAccelerationCallback?.streamController.stream.listen((dataList) {
      var list = dataList
          .map((data) => api.XIMU3_earth_acceleration_message_to_euler_angles_message(data))
          .toList();

      if (list.isNotEmpty) {
        controller.add(list);
      }
    });

    return controller.stream;
  }
}
