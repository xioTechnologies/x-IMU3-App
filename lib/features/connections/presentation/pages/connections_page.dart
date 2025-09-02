import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ximu3_app/core/routes/app_router.dart';
import 'package:ximu3_app/core/utils/font_utils.dart';
import 'package:ximu3_app/features/connections/presentation/widgets/connection_tile.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';

import '../../../../core/tab/tab_cubit.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/palette.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/network_announcement_message.dart';
import '../bloc/connection_cubit.dart';
import '../bloc/connection_state.dart';

@RoutePage()
class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ConnectionCubit>();
    return BlocProvider.value(
      value: context.read<ConnectionCubit>(),
      child: BlocListener<ConnectionCubit, ConnectionsState>(
        listener: (context, state) {
          loadingNotifier.value = state is DisconnectingState || state is ConnectionCommandSendingState;

          if (state is DisconnectErrorState) {
            AppSnack.show(context, message: Strings.errorDisconnecting);
          }
        },
        child: Scaffold(
          backgroundColor: Palette.backgroundLight,
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              context.router.push(const NewConnectionRoute());
            },
            backgroundColor: Palette.white,
            child: const Icon(Icons.add, color: Palette.backgroundLight, size: 40),
          ),
          body: MultiValueListenableBuilder(
            listenableA: loadingNotifier,
            listenableB: cubit.activeConnectionsNotifier,
            builder: (context, loading, connections, _) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constants.padding),
                    child: connections.isEmpty
                        ? const AppEmptyWidget(label: "")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  closeWhenTapped: true,
                                  child: ListView.separated(
                                    itemCount: connections.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var connection = connections[index];
                                      return ConnectionTile(
                                        onDelete: () {
                                          cubit.disconnectSingle(context.read<DataLoggerCubit>(), connection, cubit);
                                        },
                                        connection: connection,
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return const SizedBox(height: Constants.padding);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Center(
                    child: ValueListenableBuilder(
                      valueListenable: context.read<ConnectionCubit>().activeConnectionsNotifier,
                      builder: (_, value, __) {
                        return AppText(
                          text: value.isEmpty ? "No Connections" : "",
                          align: TextAlign.center,
                          size: SizeFont.xS,
                        );
                      },
                    ),
                  ),
                  Center(child: AppLoader(show: loading)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
