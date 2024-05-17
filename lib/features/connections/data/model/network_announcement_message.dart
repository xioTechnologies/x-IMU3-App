import '../../../../core/api/ffi_helpers.dart';
import '../../../../core/api/ximu3_bindings.g.dart';

class NetworkAnnouncementMessage {
  String deviceName;
  String serialNumber;
  String ipAddress;
  int? tcpPort;
  int? udpSend;
  int? udpReceive;
  int? rssi;
  int? battery;
  int? chargingStatus;

  NetworkAnnouncementMessage({
    required this.deviceName,
    required this.serialNumber,
    required this.ipAddress,
    required this.tcpPort,
    required this.udpSend,
    required this.udpReceive,
    required this.rssi,
    required this.battery,
    required this.chargingStatus,
  });

  factory NetworkAnnouncementMessage.fromPointer(XIMU3_NetworkAnnouncementMessage pointer) {
    return NetworkAnnouncementMessage(
      deviceName: FFIHelpers.convertCharArrayToString(pointer.device_name),
      serialNumber: FFIHelpers.convertCharArrayToString(pointer.serial_number),
      ipAddress: FFIHelpers.convertCharArrayToString(pointer.ip_address),
      tcpPort: pointer?.tcp_port,
      udpSend: pointer?.udp_send,
      udpReceive: pointer?.udp_receive,
      rssi: pointer?.rssi,
      battery: pointer?.battery,
      chargingStatus: pointer?.charging_status,
    );
  }

  @override
  String toString() {
    return 'XIMU3NetworkAnnouncementMessage(deviceName: $deviceName, serialNumber: $serialNumber, ipAddress: $ipAddress, tcpPort: $tcpPort, udpSend: $udpSend, udpReceive: $udpReceive, rssi: $rssi, battery: $battery, chargingStatus: $chargingStatus)';
  }
}
