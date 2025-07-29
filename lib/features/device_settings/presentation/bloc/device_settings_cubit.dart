import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/commands/domain/usecases/send_commands_usecase.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/device_settings/presentation/bloc/device_settings_state.dart';
import 'package:collection/collection.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../../core/utils/index.dart';
import '../../../commands/data/model/command_message.dart';
import '../../../connections/data/model/connection.dart';
import '../../data/model/device_settings_setting.dart';
import '../../data/model/device_settings_group.dart';

class DeviceSettingsCubit extends Cubit<DeviceSettingsState> {
  final SendCommandsUseCase sendCommandsUseCase;

  ValueNotifier<Map<String, DeviceSettingsGroup>?> deviceSettingsNotifier = ValueNotifier(null);

  final prefs = injector<SharedPreferencesAbstract>();

  DeviceSettingsCubit({
    required this.sendCommandsUseCase,
  }) : super(DeviceSettingsInitialState());

  Future<void> load(Connection connection) async {
    emit(DeviceSettingsLoadingState());

    await sendCommands((await XMLUtils.getDeviceSettingsKeys()).map((key) => CommandMessage(key, null)).toList(), connection);

    emit(DeviceSettingsLoadedState());
  }

  Future<void> sendCommands(List<CommandMessage> commands, Connection connection) async{
    if (deviceSettingsNotifier.value == null) {
      return;
    }

    final List<CommandMessage> responses = await sendCommandsUseCase.call(
      SendCommandsUseCaseParams(
        commands: commands,
        connection: connection,
      ),
    );

    deviceSettingsNotifier.value?.forEach((_, group) {
      _updateSection(responses, group);
    });

    deviceSettingsNotifier.notifyListeners();
  }


  void _updateSection(List<CommandMessage> data, DeviceSettingsGroup group) {
    group.expanded = prefs.getBool(group.name) ?? false;

    for (var setting in group.settings) {
      CommandMessage? message = data.firstWhereOrNull((message) => message.key == setting.key);
      if (message != null) {
        setting.controller?.text = message.value.toString();
        setting.value = message.value;
      }
    }

    for (var subSection in group.subGroups.values) {
      _updateSection(data, subSection);
    }
  }
}
