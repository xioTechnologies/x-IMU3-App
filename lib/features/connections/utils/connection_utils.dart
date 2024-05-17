import 'package:ximu3_app/features/connections/data/model/battery_status.dart';
import 'package:ximu3_app/features/connections/data/model/connection_info.dart';
import 'package:ximu3_app/features/connections/data/model/rssi_status.dart';

import '../../../core/api/ximu3_bindings.g.dart';
import '../../../core/utils/images.dart';
import '../data/model/connection.dart';

class ConnectionUtils {
  ConnectionUtils._();

  static String batteryIcon(BatteryStatus? batteryStatus, Connection connection) {
    if (connection.connectionInfo is TCPConnectionInfo && batteryStatus == null) {
      batteryStatus = (connection.connectionInfo as TCPConnectionInfo).batteryStatus;
    }

    if (connection.connectionInfo is UDPConnectionInfo && batteryStatus == null) {
      batteryStatus = (connection.connectionInfo as UDPConnectionInfo).batteryStatus;
    }

    if (batteryStatus == null) {
      return Images.batteryUnavailable;
    }

    if (batteryStatus.status == XIMU3_ChargingStatus.XIMU3_ChargingStatusCharging) {
      return Images.batteryCharging;
    }

    if (batteryStatus.status == XIMU3_ChargingStatus.XIMU3_ChargingStatusChargingComplete) {
      return Images.batteryChargingComplete;
    }

    if (batteryStatus.percentage <= 25) {
      return Images.battery25;
    } else if (batteryStatus.percentage <= 50) {
      return Images.battery50;
    } else if (batteryStatus.percentage <= 75) {
      return Images.battery75;
    } else {
      return Images.battery100;
    }
  }

  static String wifiIcon(RssiStatus? rssiStatus, Connection connection) {
    if (connection.connectionInfo is TCPConnectionInfo && rssiStatus == null) {
      rssiStatus = (connection.connectionInfo as TCPConnectionInfo).rssiStatus;
    }

    if (connection.connectionInfo is UDPConnectionInfo && rssiStatus == null) {
      rssiStatus = (connection.connectionInfo as UDPConnectionInfo).rssiStatus;
    }

    if (rssiStatus == null || rssiStatus.percentage < 0) {
      return Images.wifiUnavailable;
    }

    if (rssiStatus.percentage <= 25) {
      return Images.wifi25;
    } else if (rssiStatus.percentage <= 50) {
      return Images.wifi50;
    } else if (rssiStatus.percentage <= 75) {
      return Images.wifi75;
    } else {
      return Images.wifi100;
    }
  }
}
