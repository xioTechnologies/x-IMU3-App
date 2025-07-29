import '../../../../core/api/ximu3_bindings.g.dart';

class BatteryStatus {
  final double percentage;
  final double charging_status;
  final int timestamp;

  BatteryStatus({
    required this.percentage,
    required this.charging_status,
    required this.timestamp,
  });

  static BatteryStatus fromXIMU3BatteryMessage(XIMU3_BatteryMessage message) {
    return BatteryStatus(
      percentage: message.percentage,
      charging_status: message.charging_status,
      timestamp: message.timestamp,
    );
  }
}
