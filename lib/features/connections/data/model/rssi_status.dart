import '../../../../core/api/ximu3_bindings.g.dart';

class RssiStatus {
  final double percentage;
  final int timestamp;
  final double power;

  RssiStatus({
    required this.percentage,
    required this.timestamp,
    required this.power,
  });

  static RssiStatus fromXIMU3RssiMessage(XIMU3_RssiMessage message) {
    return RssiStatus(
      percentage: message.percentage,
      power: message.power,
      timestamp: message.timestamp,
    );
  }
}
