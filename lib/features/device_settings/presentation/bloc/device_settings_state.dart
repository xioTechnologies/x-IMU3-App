import 'package:equatable/equatable.dart';

abstract class DeviceSettingsState extends Equatable {}

class DeviceSettingsInitialState extends DeviceSettingsState {
  DeviceSettingsInitialState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsLoadingState extends DeviceSettingsState {
  DeviceSettingsLoadingState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsLoadedState extends DeviceSettingsState {
  DeviceSettingsLoadedState();

  @override
  List<Object> get props => [];
}
