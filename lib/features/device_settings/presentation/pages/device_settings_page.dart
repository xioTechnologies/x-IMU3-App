import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/core/widgets/app_expansion_tile.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/device_settings/presentation/bloc/device_settings_cubit.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/shared_preferences/shared_preferences_abstract.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/device_settings_setting.dart';
import '../../data/model/device_settings_group.dart';
import '../bloc/device_settings_state.dart';

@RoutePage()
class DeviceSettingsPage extends StatefulWidget {
  const DeviceSettingsPage({super.key});

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  ValueNotifier<bool> writingNotifier = ValueNotifier(false);
  final prefs = injector<SharedPreferencesAbstract>();

  void _saveExpandedState(String title, bool isExpanded, DeviceSettingsCubit cubit) async {
    _updateExpandedState(cubit.deviceSettingsNotifier.value ?? {}, title, isExpanded);
    cubit.deviceSettingsNotifier.notifyListeners();
  }

  void _updateExpandedState(Map<String, DeviceSettingsGroup> groups, String name, bool isExpanded) async {
    for (var group in groups.values) {
      if (group.name == name) {
        group.expanded = isExpanded;
        await prefs.setBool(name, isExpanded);
      }
      _updateExpandedState(group.subGroups, name, isExpanded);
    }
  }

  sendWriteCommand(String key, dynamic value, DeviceSettingsCubit cubit) {
    final selectedConnection = context.read<ConnectionCubit>().selectedConnection;

    if (selectedConnection != null) {
      cubit.writeCommand(
        key: key,
        value: value,
        connection: selectedConnection,
        cubit: context.read<ConnectionCubit>(),
      );
    }
  }

  bool _isItemVisible(DeviceSettingsSetting item, DeviceSettingsCubit cubit) {
    if (item.hideKey == null || item.hideValues == null) {
      return true;
    }

    String? currentValue;
    for (var group in (cubit.deviceSettingsNotifier.value ?? {}).values) {
      for (var groupItem in group.settings) {
        if (groupItem.key == item.hideKey) {
          currentValue = groupItem.value?.toString();
          break;
        }
      }

      if (currentValue != null) {
        break;
      }
    }

    return currentValue == null || !item.hideValues!.contains(currentValue);
  }

  bool _isSectionVisible(DeviceSettingsGroup group, DeviceSettingsCubit cubit) {
    if (group.hideKey == null || group.hideValues == null) {
      return true;
    }

    String? currentValue;
    for (var sec in (cubit.deviceSettingsNotifier.value ?? {}).values) {
      for (var groupItem in sec.settings) {
        if (groupItem.key == group.hideKey) {
          currentValue = groupItem.value?.toString();
          break;
        }
      }

      if (currentValue != null) {
        break;
      }
    }

    return currentValue == null || !group.hideValues!.contains(currentValue);
  }

  Widget _buildSection(DeviceSettingsGroup group, DeviceSettingsCubit cubit) {
    if (!_isSectionVisible(group, cubit)) {
      return Container();
    }

    List<Widget> childrenWidgets =
        group.settings.map((item) => _buildItemWidget(item, cubit)).toList();

    childrenWidgets.addAll(group.subGroups.entries.map((e) => _buildSection(e.value, cubit)));

    return AppExpansionTile(
      group: group,
      onExpansionChanged: (bool isExpanded) {
        if (mounted) {
          _saveExpandedState(group.name, isExpanded, cubit);
        }
      },
      children: childrenWidgets,
    );
  }

  Widget _buildItemWidget(DeviceSettingsSetting item, DeviceSettingsCubit cubit) {
    if (!_isItemVisible(item, cubit)) {
      return Container();
    }

    if (item.items.isNotEmpty)  {
        return _buildDropdown(item, cubit);
      }

    return _buildTextField(cubit, item);
  }

  Widget _buildTextField(DeviceSettingsCubit cubit, DeviceSettingsSetting item) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10),
      child: AppTextField(
        label: item.name,
        controller: item.controller!,
        enabled: !item.readOnly,
        onDone: (str) {
          dynamic value = str;
          if (item.type == "number")
          {
            value = num.parse(value);
          }

          sendWriteCommand(item.key!, value, cubit);
        },
      ),
    );
  }

  Widget _buildDropdown(DeviceSettingsSetting item, DeviceSettingsCubit cubit) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10),
      child: AppDropdownField(
        label: item.name,
        options: item.items ?? [],
        selectedValue: item.items?.firstWhereOrNull(
          (e) => e.value.toString() == item.value.toString(),
        ),
        onSelected: (Enumerator? enumerator) {
          if (enumerator != null && enumerator.value != item.value) {
            sendWriteCommand(item.key!, enumerator.value, cubit);

            item.value = enumerator.value;
            cubit.deviceSettingsNotifier.notifyListeners();
          }
        },
      ),
    );
  }

  _variantOfScaffold(Widget body, {DeviceSettingsCubit? cubit, bool showButtons = false}) {
    return Scaffold(
      backgroundColor: Palette.backgroundLight,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: XMLUtils.parseDeviceSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider<DeviceSettingsCubit>(
            create: (context) => injector<DeviceSettingsCubit>(),
            child: BlocConsumer<DeviceSettingsCubit, DeviceSettingsState>(
              listener: (context, state) {
                writingNotifier.value = state is DeviceSettingsWritingState;

                if (state is DeviceSettingsReadErrorState) {
                  AppSnack.show(context, message: state.message);
                }

                if (state is DeviceSettingsWriteErrorState) {
                  AppSnack.show(context, message: state.message);
                }

                FocusManager.instance.primaryFocus?.unfocus();
              },
              buildWhen: (context, state) =>
                  state is DeviceSettingsLoadErrorState ||
                  state is DeviceSettingsLoadSuccessState ||
                  state is DeviceSettingsLoadingState ||
                  state is DeviceSettingsInitialState,
              builder: (context, state) {
                var cubit = context.read<DeviceSettingsCubit>();
                cubit.deviceSettingsNotifier.value = snapshot.data!;

                if (state is DeviceSettingsInitialState) {
                  cubit.readDeviceSettings(
                    connection: context.read<ConnectionCubit>().activeConnections.first,
                    initialLoad: true,
                  );
                  return _variantOfScaffold(const AppLoader());
                }
                if (state is DeviceSettingsLoadErrorState) {
                  return _variantOfScaffold(
                    AppEmptyWidget(label: state.message),
                    cubit: cubit,
                  );
                } else if (state is DeviceSettingsLoadSuccessState) {
                  return _variantOfScaffold(
                    Stack(
                      children: [
                        Column(
                          children: [
                            AppDeviceListHeader(
                              connectionSelected: (c) {
                                cubit.readDeviceSettings(
                                  connection:
                                      context.read<ConnectionCubit>().activeConnections.first,
                                  initialLoad: true,
                                );
                              },
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                backgroundColor: Palette.darkButtonColor,
                                color: Palette.white,
                                onRefresh: () async {
                                  cubit.readDeviceSettings(
                                    connection:
                                        context.read<ConnectionCubit>().activeConnections.first,
                                    initialLoad: true,
                                  );
                                  return;
                                },
                                child: LayoutBuilder(builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                      child: ValueListenableBuilder(
                                        valueListenable: cubit.deviceSettingsNotifier,
                                        builder: (context, settings, _) {
                                          return Padding(
                                            padding: const EdgeInsets.all(Constants.padding),
                                            child: Theme(
                                              data: Theme.of(context)
                                                  .copyWith(dividerColor: Colors.transparent),
                                              child: Column(
                                                children: (settings ?? {}).values.map((group) {
                                                  return _buildSection(group, cubit);
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: writingNotifier,
                          builder: (context, loading, _) {
                            return AppLoader(show: loading);
                          },
                        ),
                      ],
                    ),
                    cubit: context.read<DeviceSettingsCubit>(),
                    showButtons: true,
                  );
                } else {
                  return _variantOfScaffold(const AppLoader());
                }
              },
            ),
          );
        } else {
          return _variantOfScaffold(const AppLoader());
        }
      },
    );
  }
}
