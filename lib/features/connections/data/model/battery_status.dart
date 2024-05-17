import '../../../../core/api/ximu3_bindings.g.dart';

class BatteryStatus {
  final double percentage;
  final double status;
  final int timestamp;

  BatteryStatus({
    required this.percentage,
    required this.status,
    required this.timestamp,
  });

  static BatteryStatus fromXIMU3BatteryMessage(XIMU3_BatteryMessage message) {
    return BatteryStatus(
      percentage: message.percentage,
      status: message.charging_status,
      timestamp: message.timestamp,
    );
  }
}
