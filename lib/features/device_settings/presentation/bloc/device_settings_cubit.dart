import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/commands/domain/usecases/read_command_usecase.dart';
import 'package:ximu3_app/features/commands/domain/usecases/write_command_usecase.dart';
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
  final WriteCommandUseCase writeCommandUseCase;
  final ReadCommandsUseCase readCommandUseCase;

  ValueNotifier<Map<String, DeviceSettingsGroup>?> deviceSettingsNotifier = ValueNotifier(null);

  final prefs = injector<SharedPreferencesAbstract>();

  DeviceSettingsCubit({
    required this.writeCommandUseCase,
    required this.readCommandUseCase,
  }) : super(DeviceSettingsInitialState());

  Future<void> readDeviceSettings({
    required Connection connection,
    bool initialLoad = false,
  }) async {
    if (deviceSettingsNotifier.value == null) {
      return;
    }

    if (initialLoad) {
      emit(DeviceSettingsLoadingState());
    } else {
      emit(DeviceSettingsReadingState());
    }

    List<String> keys = await XMLUtils.getDeviceSettingsKeys();

    final failOrSuccess = await readCommandUseCase.call(
      ReadCommandsUseCaseParams(
        keys: keys,
        connection: connection,
      ),
    );

    failOrSuccess.fold(
      (failure) {
        if (initialLoad) {
          emit(DeviceSettingsLoadErrorState(failure.message));
        } else {
          emit(DeviceSettingsReadErrorState(failure.message));
        }
      },
      (data) {
        deviceSettingsNotifier.value?.forEach((_, group) {
          _updateSection(data, group);
        });

        deviceSettingsNotifier.notifyListeners();

        if (!isClosed) {
          if (initialLoad) {
            emit(DeviceSettingsLoadSuccessState());
          } else {
            emit(DeviceSettingsReadSuccessState());
          }
        }
      },
    );
  }

  void _updateSection(List<CommandMessage> data, DeviceSettingsGroup group) {
    group.expanded = prefs.getBool(group.name) ?? false;

    for (var item in group.settings) {
      _updateItem(data, item);
    }

    for (var subSection in group.subGroups.values) {
      _updateSection(data, subSection);
    }
  }

  void _updateItem(List<CommandMessage> data, DeviceSettingsSetting setting) {
    CommandMessage? message = data.firstWhereOrNull((message) => message.key == setting.key);
    if (message != null) {
      if (setting.value != message.value) {
        setting.controller?.text = message.value.toString();
        setting.value = message.value;
      }
    }
  }

  Future<void> writeCommand({
    required String key,
    required dynamic value,
    required Connection connection,
    required ConnectionCubit cubit,
  }) async {
    emit(DeviceSettingsWritingState());

    final failOrSuccess = await writeCommandUseCase.call(
      WriteCommandUseCaseParams(
        command: CommandMessage(
          key: key,
          value: value,
        ),
        connections: [connection],
      ),
    );

    failOrSuccess.fold(
      (failure) {
        emit(DeviceSettingsWriteErrorState(failure.message));
      },
      (data) {
        emit(DeviceSettingsWriteSuccessState());
      },
    );
  }
}
