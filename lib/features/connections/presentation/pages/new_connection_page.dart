import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/core/tab/tab_cubit.dart';
import 'package:ximu3_app/core/utils/strings.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_state.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/font_utils.dart';
import '../../../../core/utils/palette.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/connection.dart';
import '../widgets/connection_tile.dart';

@RoutePage()
class NewConnectionPage extends StatefulWidget {
  const NewConnectionPage({
    super.key,
  });

  @override
  State<NewConnectionPage> createState() => _NewConnectionPageState();
}

class _NewConnectionPageState extends State<NewConnectionPage> {
  List<Connection> checkedConnections = [];
  final ValueNotifier<List<Connection>> _allConnections = ValueNotifier([]);
  ValueNotifier<int> availableConnectionsCount = ValueNotifier(0);
  bool selectAll = false;

  _variantOfScaffold(Widget body, ConnectionCubit cubit) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder(
          valueListenable: availableConnectionsCount,
          builder: (context, count, _) {
            if (count > 1) {
              return CustomAppBar(title: "${Strings.availableConnections} ($count)");
            } else {
              return const CustomAppBar(title: Strings.availableConnections);
            }
          },
        ),
      ),
      backgroundColor: Palette.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: body,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: cubit.searchingNotifier,
        builder: (context, searching, _) {
          return !searching
              ? SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(Constants.padding),
                    child: ValueListenableBuilder(
                      valueListenable: cubit.searchingNotifier,
                      builder: (context, searching, _) {
                        return searching
                            ? Container()
                            : MultiValueListenableBuilder(
                                listenableA: cubit.connectingNotifier,
                                listenableB: cubit.connectionButtonEnabledNotifier,
                                builder: (context, connecting, enabled, _) {
                                  return AppButton(
                                    loading: connecting,
                                    buttonText: Strings.connect,
                                    buttonTapped: () {
                                      cubit.newConnection(checkedConnections);
                                    },
                                    enabled:
                                        checkedConnections.isNotEmpty && enabled && !connecting,
                                  );
                                },
                              );
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  _connectionChecked(Connection connection) {
    return checkedConnections
        .where((e) => e.connectionInfo.toString() == connection.connectionInfo.toString())
        .toList()
        .isNotEmpty;
  }

  void _updateAvailableConnections(ConnectionCubit cubit, List<Connection> connections) {
    _allConnections.value = connections
        .where((c) => !cubit.activeConnections.any((e) => e.connectionInfo == c.connectionInfo))
        .toList();

    if (selectAll) {
        checkedConnections = List.from(_allConnections.value);
      }
    else {
      checkedConnections.retainWhere((element) => _allConnections.value.any((item) => item.connectionInfo.toString() == element.connectionInfo.toString()));
    }
  }

  void _updateAvailableConnectionsCount() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        availableConnectionsCount.value = _allConnections.value.length;
      }
    });
  }

  Future<void> _refreshAvailableConnections(ConnectionCubit cubit) async {
    cubit.getAvailableConnections(
        context.read<TabCubit>().networkAnnouncementCallbackResult?.pointer);
  }

  Widget _buildConnectionsList(List<Connection> allConnections) {
    return Column(
      children: [
        _buildSelectAllCheckbox(),
        const SizedBox(height: Constants.padding),
        _buildConnectionsListView(allConnections),
      ],
    );
  }

  Widget _buildSelectAllCheckbox() {
    return AppCheckboxListTile(
      content: const AppText(text: Strings.selectAll, weight: Weight.medium, size: SizeFont.L),
      checked: selectAll,
      onChanged: _onSelectAllChanged,
    );
  }

  void _onSelectAllChanged(bool checked) {
    setState(() {
      if (checked) {
        checkedConnections = List.from(_allConnections.value);
      } else {
        checkedConnections.clear();
      }

      selectAll = checked;
    });
  }

  Widget _buildConnectionItem(Connection connection) {
    return AppCheckboxListTile(
      content: ConnectionTile(connection: connection, slidable: false),
      checked: _connectionChecked(connection),
      onChanged: (bool newValue) => _onConnectionCheckedChanged(connection, newValue),
    );
  }

  void _onConnectionCheckedChanged(Connection connection, bool newValue) {
    setState(() {
      if (newValue) {
        checkedConnections.add(connection);
      } else {
        selectAll = false;
        checkedConnections.removeWhere((c) => c.connectionInfo == connection.connectionInfo);
      }
    });
  }

  void _updateCheckedConnections(List<Connection> allConnections) {
    if (selectAll) {
      for (var connection in allConnections) {
        int? exists =
            checkedConnections.indexWhere((c) => c.connectionInfo == connection.connectionInfo);
        if (exists == -1) {
          checkedConnections.add(connection);
        }
      }
    }
  }

  Widget _buildConnectionsListView(List<Connection> allConnections) {
    return Expanded(
      child: ListView.separated(
        itemCount: allConnections.length,
        itemBuilder: (context, index) => _buildConnectionItem(allConnections[index]),
        separatorBuilder: (context, index) => const SizedBox(height: Constants.padding),
      ),
    );
  }

  Widget _buildConnectionsUI(ConnectionCubit cubit) {
    return ValueListenableBuilder(
      valueListenable: _allConnections,
      builder: (context, List<Connection> allConnections, _) {
        _updateCheckedConnections(allConnections);

        return RefreshIndicator(
          backgroundColor: Palette.darkButtonColor,
          color: Palette.white,
          onRefresh: () => _refreshAvailableConnections(cubit),
          child: allConnections.isEmpty
              ? _buildEmptyConnectionsUI()
              : _buildConnectionsList(allConnections),
        );
      },
    );
  }

  Widget _buildEmptyConnectionsUI() {
    return Stack(
      children: [
        const Center(child: AppEmptyWidget(label: Strings.noConnectionsFound)),
        LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(),
            ),
          );
        }),
      ],
    );
  }

  _loadedBody(ConnectionCubit cubit, List<Connection> connections) {
    return ValueListenableBuilder(
      valueListenable: context.read<TabCubit>().networkAnnouncementNotifier,
      builder: (context, nam, _) {
        _updateAvailableConnections(cubit, connections);

        _updateAvailableConnectionsCount();

        return _buildConnectionsUI(cubit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ConnectionCubit>(),
      child: BlocConsumer<ConnectionCubit, ConnectionsState>(
        listener: (context, state) {
          if (state is ConnectSuccessState) {
            context.read<ConnectionCubit>().selectConnection(checkedConnections.first);
            context.router.pop();
          }

          if (state is ConnectErrorState) {
            AppSnack.show(context, message: state.message);
          }
        },
        buildWhen: (context, state) =>
            state is ConnectionInitialState ||
            state is ConnectionsScanningState ||
            state is ConnectionsScanErrorState ||
            state is ConnectionsScanSuccessState,
        builder: (context, state) {
          var cubit = context.read<ConnectionCubit>();
          if (state is ConnectionInitialState || state is ConnectionDummyState) {
            cubit.getAvailableConnections(
                context.read<TabCubit>().networkAnnouncementCallbackResult?.pointer);
            return _variantOfScaffold(const AppLoader(), cubit);
          } else if (state is ConnectionsScanningState) {
            return _variantOfScaffold(const AppLoader(), cubit);
          } else if (state is ConnectionsScanSuccessState) {
            if (state.connections.isEmpty) {
              checkedConnections.clear();
            }
            return _variantOfScaffold(_loadedBody(cubit, state.connections), cubit);
          } else {
            return _variantOfScaffold(Container(), cubit);
          }
        },
      ),
    );
  }
}
