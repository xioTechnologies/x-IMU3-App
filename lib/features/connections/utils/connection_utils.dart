import 'package:ximu3_app/features/connections/data/model/battery_status.dart';
import 'package:ximu3_app/features/connections/data/model/connection_info.dart';
import 'package:ximu3_app/features/connections/data/model/rssi_status.dart';

import '../../../core/api/base_api.dart';
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

    switch (API.api.XIMU3_charging_status_from_float(batteryStatus.charging_status)) {
      case XIMU3_ChargingStatus.XIMU3_ChargingStatusNotConnected:
        if (batteryStatus.percentage <= 25) {
          return Images.battery25;
        }
        if (batteryStatus.percentage <= 50) {
          return Images.battery50;
        }
        if (batteryStatus.percentage <= 75) {
          return Images.battery75;
        }
        return Images.battery100;

      case XIMU3_ChargingStatus.XIMU3_ChargingStatusCharging:
        return Images.batteryCharging;

      case XIMU3_ChargingStatus.XIMU3_ChargingStatusChargingComplete:
        return Images.batteryChargingComplete;

      case XIMU3_ChargingStatus.XIMU3_ChargingStatusChargingOnHold:
        return Images.batteryChargingOnHold;
    }
  }

  static String rssiIcon(RssiStatus? rssiStatus, Connection connection) {
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
    }
    if (rssiStatus.percentage <= 50) {
      return Images.wifi50;
    }
    if (rssiStatus.percentage <= 75) {
      return Images.wifi75;
    }
    return Images.wifi100;
  }
}
