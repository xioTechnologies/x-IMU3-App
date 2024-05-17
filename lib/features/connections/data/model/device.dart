import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';

import '../../../../core/api/ffi_helpers.dart';

class Device {
  String name;
  String serialNumber;

  Device({
    required this.name,
    required this.serialNumber,
  });

  static Device fromXIMU3(XIMU3_Device device) {
    return Device(
      name: FFIHelpers.convertCharArrayToString(device.device_name),
      serialNumber: FFIHelpers.convertCharArrayToString(device.serial_number),
    );
  }
}
