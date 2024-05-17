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

class DeviceSettingsLoadErrorState extends DeviceSettingsState {
  final String message;

  DeviceSettingsLoadErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceSettingsLoadSuccessState extends DeviceSettingsState {
  DeviceSettingsLoadSuccessState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsReadingState extends DeviceSettingsState {
  DeviceSettingsReadingState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsReadErrorState extends DeviceSettingsState {
  final String message;

  DeviceSettingsReadErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceSettingsReadSuccessState extends DeviceSettingsState {
  DeviceSettingsReadSuccessState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsWritingState extends DeviceSettingsState {
  DeviceSettingsWritingState();

  @override
  List<Object> get props => [];
}

class DeviceSettingsWriteErrorState extends DeviceSettingsState {
  final String message;

  DeviceSettingsWriteErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceSettingsWriteSuccessState extends DeviceSettingsState {
  DeviceSettingsWriteSuccessState();

  @override
  List<Object> get props => [];
}
