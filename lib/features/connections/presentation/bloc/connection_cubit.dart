import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/commands/data/model/command_message.dart';
import 'package:ximu3_app/features/commands/domain/usecases/write_command_usecase.dart';
import 'package:ximu3_app/features/connections/data/model/connection_info.dart';
import 'package:ximu3_app/features/connections/domain/usecases/new_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/new_manual_udp_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';
import 'package:ximu3_app/features/graphs/data/model/graph.dart';

import '../../../../core/api/base_api.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/utils/index.dart';
import '../../data/model/callback.dart';
import '../../data/model/connection.dart';
import '../../data/model/device.dart';
import '../../domain/usecases/get_available_connections_async_usecase.dart';
import 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionsState> {
  final NewConnectionUseCase newConnectionUseCase;
  final NewManualUDPConnectionUseCase newManualUDPConnectionUseCase;
  final GetAvailableConnectionsAsyncUseCase getAvailableConnectionsAsyncUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  final WriteCommandUseCase writeCommandUseCase;

  final ValueNotifier<List<Connection>> _activeConnections = ValueNotifier([]);
  Connection? _selectedConnection;

  static NativeLibrary get api => API.api;

  selectConnection(Connection? connection) {
    _selectedConnection = connection;
  }

  Connection? get selectedConnection => _activeConnections.value.firstWhereOrNull(
        (c) => c.connectionInfo?.label == _selectedConnection?.connectionInfo?.label,
      );

  List<Connection> get activeConnections => _activeConnections.value;

  ValueNotifier<List<Connection>> get activeConnectionsNotifier => _activeConnections;

  ValueNotifier<bool> connectingNotifier = ValueNotifier(false);
  ValueNotifier<bool> searchingNotifier = ValueNotifier(false);
  ValueNotifier<bool> connectionButtonEnabledNotifier = ValueNotifier(false);

  ConnectionCubit({
    required this.newConnectionUseCase,
    required this.getAvailableConnectionsAsyncUseCase,
    required this.removeConnectionUseCase,
    required this.writeCommandUseCase,
    required this.newManualUDPConnectionUseCase,
  }) : super(ConnectionInitialState());

  static int _colorIndex = 0;

  Color _getNextColor() {
    Color nextColor = Constants.connectionColors[_colorIndex];
    _colorIndex = (_colorIndex + 1) % Constants.connectionColors.length;
    return nextColor;
  }

  void _resetColorCycle() {
    if (_activeConnections.value.isEmpty) {
      _colorIndex = 0;
    }
  }

  void getAvailableConnections(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer) async {
    connectionButtonEnabledNotifier.value = false;
    searchingNotifier.value = true;

    emit(ConnectionsScanningState());

    final failOrSuccess =
        await getAvailableConnectionsAsyncUseCase.call(networkAnnouncementPointer);

    failOrSuccess.fold(
      (failure) {
        emit(ConnectionsScanErrorState(failure.message));
      },
      (data) {
        connectionButtonEnabledNotifier.value = data.isNotEmpty;

        emit(ConnectionsScanSuccessState(data));
      },
    );

    searchingNotifier.value = false;

    emit(ConnectionDummyState());
  }

  void newManualUDPConnection(String ipAddress, String sendPort, String receivePort) {
    connectingNotifier.value = true;
    connectingNotifier.notifyListeners();

    final failOrSuccess = newManualUDPConnectionUseCase.call(
      NewManualUDPConnectionUseCaseParams(
        ipAddress: ipAddress,
        sendPort: int.parse(sendPort),
        receivePort: int.parse(receivePort),
      ),
    );

    failOrSuccess.fold(
      (failure) {
        emit(ConnectErrorState(failure.message));
      },
      (connectionPointer) {
        Color color = _getNextColor();

        Connection connection = Connection(
          device: Device(name: "N/A", serialNumber: "N/A"),
          connectionInfo: UDPConnectionInfo(
            ipAddress: ipAddress,
            sendPort: int.parse(sendPort),
            receivePort: int.parse(receivePort),
            label: "UDP $ipAddress:$sendPort, $receivePort",
          ),
          connectionType: XIMU3_ConnectionType.XIMU3_ConnectionTypeUdp,
          color: color,
          connectionPointer: connectionPointer,
        );

        connection.addPermanentStatisticsCallback();
        connection.addPermanentBatteryCallback();
        connection.addPermanentRssiCallback();
        connection.addPermanentErrorCallback();

        api.XIMU3_connection_ping(connectionPointer!);

        activeConnections.add(connection);
        activeConnectionsNotifier.notifyListeners();

        emit(ManualConnectSuccessState(connection));
      },
    );

    connectingNotifier.value = false;
    connectingNotifier.notifyListeners();

    emit(ConnectionInitialState());
  }

  void newConnection(List<Connection> connections) {
    connectingNotifier.value = true;
    connectingNotifier.notifyListeners();

    for (var connection in connections) {
      final failOrSuccess = newConnectionUseCase.call(
        NewConnectionUseCaseParams(connection: connection),
      );

      failOrSuccess.fold(
        (failure) {
          emit(ConnectErrorState(failure.message));
        },
        (connectionPointer) {
          Color color = _getNextColor();
          connection.color = color;
          connection.connectionPointer = connectionPointer;
          connection.addPermanentStatisticsCallback();
          connection.addPermanentBatteryCallback();
          connection.addPermanentRssiCallback();
          connection.addPermanentErrorCallback();

          api.XIMU3_connection_ping(connectionPointer!);

          activeConnections.add(connection);
          activeConnectionsNotifier.notifyListeners();
        },
      );
    }

    connectingNotifier.value = false;
    connectingNotifier.notifyListeners();

    emit(ConnectSuccessState());

    emit(ConnectionInitialState());
  }

  void disconnectSingle(
    DataLoggerCubit dataLoggerCubit,
    Connection connection,
    ConnectionCubit cubit,
  ) async {
    emit(DisconnectingState());

    await dataLoggerCubit.stopSession();

    final failOrSuccess = removeConnectionUseCase.call(
      RemoveConnectionUseCaseParams(
        connections: [connection],
        cubit: cubit,
      ),
    );

    failOrSuccess.fold(
      (failure) {
        emit(DisconnectErrorState(failure.message));
      },
      (data) {
        activeConnections.removeWhere((c) => c.connectionInfo == connection.connectionInfo);
        activeConnectionsNotifier.notifyListeners();

        _resetColorCycle();

        connection.dispose();

        emit(DisconnectSuccessState());
        emit(ConnectionInitialState());
      },
    );
  }

  Stream? getActiveConnectionGraphStream(Graph graph) {
    final streams = {
      Strings.gyroscope: selectedConnection?.inertialStream,
      Strings.accelerometer: selectedConnection?.inertialStream,
      Strings.magnetometer: selectedConnection?.magnetometerStream,
      Strings.eulerAngles: selectedConnection?.unifiedEulerAnglesStream,
      Strings.linearAccelerometer: selectedConnection?.linearAccelerometerStream,
      Strings.earthAccelerometer: selectedConnection?.linearAccelerometerStream,
      Strings.highGAccelerometer: selectedConnection?.highGAccelerometerStream,
      Strings.temperatureTitle: selectedConnection?.temperatureStream,
      Strings.batteryPercentage: selectedConnection?.batteryStream,
      Strings.batteryVoltage: selectedConnection?.batteryStream,
      Strings.rssiPercentage: selectedConnection?.rssiStream,
      Strings.rssiPower: selectedConnection?.rssiStream,
      Strings.serialAccessoryCsvs: selectedConnection?.serialAccessoryStream,
      Strings.receivedMessageRate: selectedConnection?.statisticsStream,
      Strings.receivedDataRate: selectedConnection?.statisticsStream,
    };

    return streams[graph.title];
  }

  removeCallbacks(List<Connection> connections) {
    for (var connection in connections) {
      removeCallback(connection.statisticsCallback, connection);
      removeCallback(connection.inertialCallback, connection);
      removeCallback(connection.magnetometerCallback, connection);
      removeCallback(connection.quaternionCallback, connection);
      removeCallback(connection.rotationMatrixCallback, connection);
      removeCallback(connection.eulerAnglesCallback, connection);
      removeCallback(connection.linearAccelerationCallback, connection);
      removeCallback(connection.earthAccelerationCallback, connection);
      removeCallback(connection.highGAccelerometerCallback, connection);
      removeCallback(connection.temperatureCallback, connection);
      removeCallback(connection.batteryCallback, connection);
      removeCallback(connection.rssiCallback, connection);
      removeCallback(connection.serialAccessoryCallback, connection);
    }
  }

  removeCallback<T>(Callback? callback, Connection connection) {
    if (callback != null && callback.callbackId != null) {
      api.XIMU3_connection_remove_callback(
        connection.connectionPointer!,
        callback.callbackId!,
      );

      print('Remove callback ID ${callback.callbackId} for ${connection.connectionInfo?.label}');

      callback.clear();
    }
  }

  void sendCommand({
    required String key,
    required dynamic value,
    required Connection connection,
  }) async {
    emit(ConnectionCommandSendingState());

    await writeCommandUseCase.call(
      WriteCommandUseCaseParams(
        command: CommandMessage(key: key, value: value),
        connections: [connection],
      ),
    );

    emit(ConnectionCommandSentState());
  }
}
