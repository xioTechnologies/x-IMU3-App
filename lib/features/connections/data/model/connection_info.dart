import 'package:equatable/equatable.dart';
import 'package:ximu3_app/features/connections/data/datasource/connections_datasource.dart';
import 'package:ximu3_app/features/connections/data/model/rssi_status.dart';

import '../../../../core/api/ffi_helpers.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import 'battery_status.dart';

class ConnectionInfo extends Equatable {
  final String? label;

  const ConnectionInfo({required this.label});

  @override
  List<Object?> get props => [label];
}

class USBConnectionInfo extends ConnectionInfo {
  final String portName;

  const USBConnectionInfo({
    required this.portName,
    String? label,
  }) : super(label: label);

  static USBConnectionInfo fromXIMU3(XIMU3_UsbConnectionInfo info) {
    return USBConnectionInfo(
      portName: FFIHelpers.convertCharArrayToString(info.port_name),
      label: ConnectionsAPI.instance.usbConnectionInfo(info),
    );
  }
}

class SerialConnectionInfo extends ConnectionInfo {
  final String portName;
  final int baudRate;
  final bool rtsCtsEnabled;

  const SerialConnectionInfo({
    required this.portName,
    required this.baudRate,
    required this.rtsCtsEnabled,
    super.label,
  });

  static SerialConnectionInfo fromXIMU3(XIMU3_SerialConnectionInfo info) {
    return SerialConnectionInfo(
      portName: FFIHelpers.convertCharArrayToString(info.port_name),
      baudRate: info.baud_rate,
      rtsCtsEnabled: info.rts_cts_enabled,
      label: ConnectionsAPI.instance.serialConnectionInfo(info),
    );
  }
}

class BluetoothConnectionInfo extends ConnectionInfo {
  final String portName;

  const BluetoothConnectionInfo({
    required this.portName,
    String? label,
  }) : super(label: label);

  static BluetoothConnectionInfo fromXIMU3(XIMU3_BluetoothConnectionInfo info) {
    return BluetoothConnectionInfo(
      portName: FFIHelpers.convertCharArrayToString(info.port_name),
      label: ConnectionsAPI.instance.bluetoothConnectionInfo(info),
    );
  }
}

class TCPConnectionInfo extends ConnectionInfo {
  final String ipAddress;
  final int port;
  final BatteryStatus? batteryStatus;
  final RssiStatus? rssiStatus;

  const TCPConnectionInfo({
    required this.ipAddress,
    required this.port,
    this.batteryStatus,
    this.rssiStatus,
    String? label,
  }) : super(label: label);

  static TCPConnectionInfo fromXIMU3(XIMU3_TcpConnectionInfo info) {
    return TCPConnectionInfo(
      ipAddress: FFIHelpers.convertCharArrayToString(info.ip_address),
      port: info.port,
      label: ConnectionsAPI.instance.tcpConnectionInfo(info),
    );
  }
}

class UDPConnectionInfo extends ConnectionInfo {
  final String ipAddress;
  final int sendPort;
  final int receivePort;
  final BatteryStatus? batteryStatus;
  final RssiStatus? rssiStatus;

  const UDPConnectionInfo({
    required this.ipAddress,
    required this.sendPort,
    required this.receivePort,
    this.batteryStatus,
    this.rssiStatus,
    String? label,
  }) : super(label: label);

  static UDPConnectionInfo fromXIMU3(XIMU3_UdpConnectionInfo info) {
    return UDPConnectionInfo(
      ipAddress: FFIHelpers.convertCharArrayToString(info.ip_address),
      sendPort: info.send_port,
      receivePort: info.receive_port,
      label: ConnectionsAPI.instance.udpConnectionInfo(info),
    );
  }
}
