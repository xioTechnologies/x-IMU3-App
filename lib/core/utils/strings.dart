import 'constants.dart';

class Strings {
  static const appName = "x-IMU3";

  //Pages
  static const commands = "Commands";
  static const connections = "Connections";
  static const dataLogger = "Data Logger";
  static const deviceSettings = "Device Settings";
  static const graphs = "Graphs";

  //Graph titles
  static const accelerometer = "Accelerometer";
  static const batteryPercentage = "Battery Percentage";
  static const batteryVoltage = "Battery Voltage";
  static const earthAccelerometer = "Earth Accelerometer";
  static const eulerAngles = "Euler Angles";
  static const gyroscope = "Gyroscope";
  static const highGAccelerometer = "High-g Accelerometer";
  static const linearAccelerometer = "Linear Accelerometer";
  static const magnetometer = "Magnetometer";
  static const quaternion = "Quaternion";
  static const receivedDataRate = "Received Data Rate";
  static const receivedMessageRate = "Received Message Rate";
  static const rotationMatrix = "Rotation Matrix";
  static const rssiPercentage = "RSSI Percentage";
  static const rssiPower = "RSSI Power";
  static const serialAccessoryCsvs = "Serial Accessory CSVs";
  static const temperatureTitle = "Temperature";

  //Graph sections
  static const ahrs = "AHRS";
  static const connection = "CONNECTION";
  static const sensors = "SENSORS";
  static const serialAccessory = "SERIAL ACCESSORY";
  static const status = "STATUS";

  //Graph axes
  static const acceleration = "Acceleration (g)";
  static const angle = "Angle (°)";
  static const angularRate = "Angular Rate (°/s)";
  static const csv = "CSV";
  static const intensity = "Intensity (a.u.)";
  static const percentage = "Percentage (%)";
  static const power = "Power (dBm)";
  static const temperatureC = "Temperature (°C)";
  static const throughputKB = "Throughput (kB/s)";
  static const throughputMessages = "Throughput (messages/s)";
  static const time = "Time (s)";
  static const voltage = "Voltage (V)";

  //Graph legend
  static const pitch = "Pitch";
  static const roll = "Roll";
  static const x = "X";
  static const y = "Y";
  static const yaw = "Yaw";
  static const z = "Z";

  //Snack bar
  static const errorDisconnecting = "Error disconnecting";
  static const maximumGraphsAllowed =
      "Maximum of ${Constants.graphLimit} graphs allowed";
  static const unableToConnect = "Unable to connect";
  static const unableToConnectUdp = "Unable to connect to UDP manual";
  static const unableToOpen = "Unable to open network announcement socket";

  //Device settings XML
  static const enumerator = "Enumerator";
  static const enums = "Enum";
  static const group = "Group";
  static const hideKey = "hideKey";
  static const hideValues = "hideValues";
  static const key = "key";
  static const name = "name";
  static const readOnly = "readOnly";
  static const type = "type";
  static const value = "value";

  //Other
  static const areYouSure = "Are You Sure?";
  static const areYouSureContent =
      "Are you sure you want to shutdown all devices?";
  static const availableConnections = "Available Connections";
  static const cancel = "Cancel";
  static const command = "Command";
  static const commandHistory = "Command History";
  static const connect = "Connect";
  static const disabled = "Disabled";
  static const enabled = "Enabled";
  static const ipAddress = "IP Address";
  static const newUdpConnection = "New UDP Connection";
  static const noConnections = "No Connections";
  static const noConnectionsFound = "No Connections Found";
  static const noData = "No Data";
  static const note = "Note";
  static const receivePort = "Receive Port";
  static const search = "Search";
  static const selectAll = "Select All";
  static const send = "Send";
  static const sendPort = "Send Port";
  static const sessionName = "Session Name";
  static const setting = "Setting";
  static const shutdown = "Shutdown";
  static const start = "Start";
  static const stopwatchPlaceholder = "00:00:00.000";
  static const storageUsed = "Storage Used";
  static const yes = "Yes";
  static const zeroHeading = "Zero Heading";
}
