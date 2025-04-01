import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/main.dart';

import '../../../../core/api/base_api.dart';
import '../../../../core/api/ffi_helpers.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/usecases/add_network_announcement_usecase.dart';
import '../model/index.dart';

class ConnectionsAPI {
  static final ConnectionsAPI _instance = ConnectionsAPI._internal();
  static ConnectionsAPI get instance => _instance;

  ConnectionsAPI._internal();

  NativeCallable<Void Function(XIMU3_NetworkAnnouncementMessage, Pointer<Void>)>?
      _networkAnnouncementCallback;

  static final _networkAnnouncementDataStreamController =
      StreamController<XIMU3_NetworkAnnouncementMessage>.broadcast();

  Stream<XIMU3_NetworkAnnouncementMessage> get networkAnnouncementDataStream =>
      _networkAnnouncementDataStreamController.stream;

  Future<List<Connection>> getAvailableConnectionsAsync() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_getAvailableConnections, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;

    final response = Completer<List<Connection>>();
    final responsePort = ReceivePort();
    sendPort.send([responsePort.sendPort]);

    responsePort.listen((data) {
      response.complete(data as List<Connection>);
    });

    return response.future;
  }

  static void _getAvailableConnections(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final responsePort = message[0] as SendPort;

      final result = _instance.getAvailableConnections();

      responsePort.send(result);
    });
  }

  List<Connection> getAvailableConnections() {
    XIMU3_Devices devices = API.api.XIMU3_port_scanner_scan();
    Pointer<XIMU3_Device> listDevices = devices.array.cast<XIMU3_Device>();

    List<Connection> connections = [];

    for (int i = 0; i < devices.length; i++) {
      XIMU3_Device nativeDevice = listDevices.elementAt(i).ref;

      var connection = Connection(
        device: Device.fromXIMU3(nativeDevice),
        connectionType: nativeDevice.connection_type,
      );

      switch (nativeDevice.connection_type) {
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeUsb:
          connection.connectionInfo = USBConnectionInfo.fromXIMU3(
            nativeDevice.usb_connection_info,
          );
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeTcp:
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeUdp:
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeSerial:
          connection.connectionInfo = SerialConnectionInfo.fromXIMU3(
            nativeDevice.serial_connection_info,
          );
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeBluetooth:
          connection.connectionInfo = BluetoothConnectionInfo.fromXIMU3(
            nativeDevice.bluetooth_connection_info,
          );
        case XIMU3_ConnectionType.XIMU3_ConnectionTypeFile:
      }

      connections.add(connection);
    }

    return connections;
  }

  XIMU3_TcpConnectionInfo networkAnnouncementToTCPConnectionInfo(
      XIMU3_NetworkAnnouncementMessage message) {
      return API.api.XIMU3_network_announcement_message_to_tcp_connection_info(message);
  }

  XIMU3_UdpConnectionInfo networkAnnouncementToUDPConnectionInfo(
      XIMU3_NetworkAnnouncementMessage message) {
    return API.api.XIMU3_network_announcement_message_to_udp_connection_info(message);
  }

  String usbConnectionInfo(XIMU3_UsbConnectionInfo? connectionInfo) {
    if (connectionInfo != null) {
      return API.api.XIMU3_usb_connection_info_to_string(connectionInfo).cast<Utf8>().toDartString();
    }
    return "";
  }

  String serialConnectionInfo(XIMU3_SerialConnectionInfo? connectionInfo) {
    if (connectionInfo != null) {
      return API.api.XIMU3_serial_connection_info_to_string(connectionInfo).cast<Utf8>().toDartString();
    }
    return "";
  }

  String bluetoothConnectionInfo(XIMU3_BluetoothConnectionInfo? connectionInfo) {
    if (connectionInfo != null) {
      return API.api.XIMU3_bluetooth_connection_info_to_string(connectionInfo)
          .cast<Utf8>()
          .toDartString();
    }
    return "";
  }

  String tcpConnectionInfo(XIMU3_TcpConnectionInfo? connectionInfo) {
    if (connectionInfo != null) {
      return API.api.XIMU3_tcp_connection_info_to_string(connectionInfo).cast<Utf8>().toDartString();
    }
    return "";
  }

  String udpConnectionInfo(XIMU3_UdpConnectionInfo? connectionInfo) {
    if (connectionInfo != null) {
      return API.api.XIMU3_udp_connection_info_to_string(connectionInfo).cast<Utf8>().toDartString();
    }
    return "";
  }

  Pointer<XIMU3_Connection>? newManualUDPConnection(
      String ipAddress, int sendPort, int receivePort) {
    Pointer<XIMU3_Connection>? connectionPointer;

    final connectionInfoPointer = calloc<XIMU3_UsbConnectionInfo>();

    connectionPointer = processManualUDPConnection(ipAddress, sendPort, receivePort);

    if (connectionPointer != null) {
      XIMU3_Result result = API.api.XIMU3_connection_open(connectionPointer);
      if (result == XIMU3_Result.XIMU3_ResultOk) {
        return connectionPointer;
      } else {
        AppSnack.show(globalBuildContext, message: Strings.unableToConnectUdp);
      }
      calloc.free(connectionPointer);
    }

    calloc.free(connectionInfoPointer);

    return null;
  }

  Pointer<XIMU3_Connection>? newConnection(Connection connection) {
    Pointer<XIMU3_Connection>? connectionPointer;

    final connectionInfoPointer = calloc<XIMU3_UsbConnectionInfo>();

    switch (connection.connectionType) {
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeUsb:
        connectionPointer = processUSBConnection(connection);
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeTcp:
        connectionPointer = processTCPConnection(connection);
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeUdp:
        connectionPointer = processUDPConnection(connection);
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeBluetooth:
        connectionPointer = processBluetoothConnection(connection);
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeSerial:
        connectionPointer = processBluetoothConnection(connection);
      case XIMU3_ConnectionType.XIMU3_ConnectionTypeFile:
      case null:
    }

    if (connectionPointer != null) {
      XIMU3_Result result = API.api.XIMU3_connection_open(connectionPointer);
      if (result == XIMU3_Result.XIMU3_ResultOk) {
        return connectionPointer;
      } else {
        AppSnack.show(globalBuildContext, message: Strings.unableToConnect);
      }
      calloc.free(connectionPointer);
    }

    calloc.free(connectionInfoPointer);

    return null;
  }

  Pointer<XIMU3_Connection>? processUSBConnection(Connection connection) {
    final connectionInfoPointer = calloc<XIMU3_UsbConnectionInfo>();

    XIMU3_UsbConnectionInfo connectionInfo = connectionInfoPointer.ref;

    List<int> portNameBytes = (connection.connectionInfo as USBConnectionInfo).portName.codeUnits;

    for (int i = 0; i < portNameBytes.length; i++) {
      connectionInfo.port_name[i] = portNameBytes[i];
    }

    connectionInfo.port_name[portNameBytes.length] = 0;

    return API.api.XIMU3_connection_new_usb(connectionInfo);
  }

  Pointer<XIMU3_Connection>? processBluetoothConnection(Connection connection) {
    final connectionInfoPointer = calloc<XIMU3_BluetoothConnectionInfo>();

    XIMU3_BluetoothConnectionInfo connectionInfo = connectionInfoPointer.ref;

    List<int> portNameBytes =
        (connection.connectionInfo as BluetoothConnectionInfo).portName.codeUnits;

    for (int i = 0; i < portNameBytes.length; i++) {
      connectionInfo.port_name[i] = portNameBytes[i];
    }

    connectionInfo.port_name[portNameBytes.length] = 0;

    return API.api.XIMU3_connection_new_bluetooth(connectionInfo);
  }

  Pointer<XIMU3_Connection>? processSerialConnection(Connection connection) {
    final connectionInfoPointer = calloc<XIMU3_SerialConnectionInfo>();

    XIMU3_SerialConnectionInfo connectionInfo = connectionInfoPointer.ref;
    connectionInfo.baud_rate = (connection.connectionInfo as SerialConnectionInfo).baudRate;
    connectionInfo.rts_cts_enabled =
        (connection.connectionInfo as SerialConnectionInfo).rtsCtsEnabled;

    List<int> portNameBytes =
        (connection.connectionInfo as SerialConnectionInfo).portName.codeUnits;

    for (int i = 0; i < portNameBytes.length; i++) {
      connectionInfo.port_name[i] = portNameBytes[i];
    }

    connectionInfo.port_name[portNameBytes.length] = 0;

    return API.api.XIMU3_connection_new_serial(connectionInfo);
  }

  Pointer<XIMU3_Connection>? processTCPConnection(Connection connection) {
    final connectionInfoPointer = calloc<XIMU3_TcpConnectionInfo>();

    XIMU3_TcpConnectionInfo connectionInfo = connectionInfoPointer.ref;
    connectionInfo.port = (connection.connectionInfo as TCPConnectionInfo).port;

    List<int> ipAddressBytes = (connection.connectionInfo as TCPConnectionInfo).ipAddress.codeUnits;

    for (int i = 0; i < ipAddressBytes.length; i++) {
      connectionInfo.ip_address[i] = ipAddressBytes[i];
    }

    connectionInfo.ip_address[ipAddressBytes.length] = 0;

    return API.api.XIMU3_connection_new_tcp(connectionInfo);
  }

  Pointer<XIMU3_Connection>? processManualUDPConnection(
      String ipAddress, int sendPort, int receivePort) {
    final connectionInfoPointer = calloc<XIMU3_UdpConnectionInfo>();

    XIMU3_UdpConnectionInfo connectionInfo = connectionInfoPointer.ref;
    connectionInfo.send_port = sendPort;
    connectionInfo.receive_port = receivePort;

    List<int> ipAddressBytes = ipAddress.codeUnits;

    for (int i = 0; i < ipAddressBytes.length; i++) {
      connectionInfo.ip_address[i] = ipAddressBytes[i];
    }

    connectionInfo.ip_address[ipAddressBytes.length] = 0;

    return API.api.XIMU3_connection_new_udp(connectionInfo);
  }

  Pointer<XIMU3_Connection>? processUDPConnection(Connection connection) {
    final connectionInfoPointer = calloc<XIMU3_UdpConnectionInfo>();

    XIMU3_UdpConnectionInfo connectionInfo = connectionInfoPointer.ref;
    connectionInfo.send_port = (connection.connectionInfo as UDPConnectionInfo).sendPort;
    connectionInfo.receive_port = (connection.connectionInfo as UDPConnectionInfo).receivePort;

    List<int> ipAddressBytes = (connection.connectionInfo as UDPConnectionInfo).ipAddress.codeUnits;

    for (int i = 0; i < ipAddressBytes.length; i++) {
      connectionInfo.ip_address[i] = ipAddressBytes[i];
    }

    connectionInfo.ip_address[ipAddressBytes.length] = 0;

    return API.api.XIMU3_connection_new_udp(connectionInfo);
  }

  bool removeConnection(List<Connection> connections, ConnectionCubit cubit) {
    cubit.removeCallbacks(connections);

    for (var connection in connections) {
      if (connection.connectionPointer != null) {
        API.api.XIMU3_connection_close(connection.connectionPointer!);
        API.api.XIMU3_connection_free(connection.connectionPointer!);
      }
    }
    return true;
  }

  NetworkAnnouncementCallbackResult? addNetworkAnnouncementCallback(
      AddNetworkAnnouncementUseCaseParams params) {
    Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer =
        API.api.XIMU3_network_announcement_new();

    _networkAnnouncementCallback = NativeCallable<
        ffi.Void Function(XIMU3_NetworkAnnouncementMessage data,
            ffi.Pointer<ffi.Void> context)>.listener(networkAnnouncementCallbackResult);

    if (_networkAnnouncementCallback != null) {
      int callbackId = API.api.XIMU3_network_announcement_add_callback(
          networkAnnouncementPointer, _networkAnnouncementCallback!.nativeFunction, ffi.nullptr);

      XIMU3_Result result = API.api.XIMU3_network_announcement_get_result(networkAnnouncementPointer);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (result == XIMU3_Result.XIMU3_ResultError) {
          AppSnack.show(params.context, message: Strings.unableToOpen);
        }
      });

      return NetworkAnnouncementCallbackResult(
          callbackId: callbackId, pointer: networkAnnouncementPointer);
    }
    return null;
  }

  static void networkAnnouncementCallbackResult(
      XIMU3_NetworkAnnouncementMessage data, ffi.Pointer<ffi.Void> context) {
    _networkAnnouncementDataStreamController.add(data);
  }

  void removeNetworkAnnouncementCallback(
      {required int callbackId, required Pointer<XIMU3_NetworkAnnouncement> pointer}) {
    API.api.XIMU3_network_announcement_remove_callback(pointer, callbackId);
  }

  Future<List<Connection?>> getMessagesAfterShortDelayAsync(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer) async {
    if (networkAnnouncementPointer == null) {
      return [];
    }

    final receivePort = ReceivePort();
    await Isolate.spawn(_getMessagesAfterShortDelay, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;

    final response = Completer<List<Connection?>>();
    final responsePort = ReceivePort();

    sendPort.send([responsePort.sendPort, networkAnnouncementPointer.address]);

    responsePort.listen((data) {
      response.complete(data as List<Connection?>);
    });

    return response.future;
  }

  static void _getMessagesAfterShortDelay(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final responsePort = message[0] as SendPort;
      final networkAnnouncementPointer = message[1] == null ? null : message[1] as int;

      final result = _instance.getMessagesAfterShortDelay(networkAnnouncementPointer == null
          ? null
          : Pointer.fromAddress(networkAnnouncementPointer));

      responsePort.send(result);
    });
  }

  List<Connection> getMessagesAfterShortDelay(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer) {
    if (networkAnnouncementPointer == null) {
      return [];
    }

    XIMU3_NetworkAnnouncementMessages messages =
        API.api.XIMU3_network_announcement_get_messages_after_short_delay(networkAnnouncementPointer);

    List<Connection> connections = [];

    for (int index = 0; index < messages.length; index++) {
      var message = messages.array.elementAt(index).ref;

      var tcpConnectionInfo = _instance.networkAnnouncementToTCPConnectionInfo(message);
      var udpConnectionInfo = _instance.networkAnnouncementToUDPConnectionInfo(message);

      var device = Device(
        name: FFIHelpers.convertCharArrayToString(message.device_name),
        serialNumber: FFIHelpers.convertCharArrayToString(message.serial_number),
      );

      var batteryStatus = BatteryStatus(
        status: message.charging_status.index.toDouble(),
        percentage: message.battery.toDouble(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      var rssiStatus = RssiStatus(
        percentage: message.rssi.toDouble(),
        power: 0,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      connections.add(
        Connection(
          device: device,
          connectionType: XIMU3_ConnectionType.XIMU3_ConnectionTypeTcp,
          connectionInfo: TCPConnectionInfo(
            batteryStatus: batteryStatus,
            rssiStatus: rssiStatus,
            ipAddress: FFIHelpers.convertCharArrayToString(tcpConnectionInfo.ip_address),
            port: tcpConnectionInfo.port,
            label: ConnectionsAPI.instance.tcpConnectionInfo(tcpConnectionInfo),
          ),
        ),
      );

      connections.add(
        Connection(
          device: device,
          connectionInfo: UDPConnectionInfo(
            batteryStatus: batteryStatus,
            rssiStatus: rssiStatus,
            ipAddress: FFIHelpers.convertCharArrayToString(udpConnectionInfo.ip_address),
            sendPort: message.udp_send,
            receivePort: message.udp_receive,
            label: ConnectionsAPI.instance.udpConnectionInfo(udpConnectionInfo),
          ),
          connectionType: XIMU3_ConnectionType.XIMU3_ConnectionTypeUdp,
        ),
      );
    }

    return connections;
  }
}
