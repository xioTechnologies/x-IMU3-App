import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/commands/presentation/bloc/command_cubit.dart';
import 'package:ximu3_app/features/commands/presentation/bloc/command_state.dart';
import 'package:ximu3_app/features/commands/presentation/widgets/command_card.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/command_message.dart';

@RoutePage()
class CommandsPage extends StatefulWidget {
  const CommandsPage({super.key});

  @override
  State<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  _buildGrid(CommandCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(Constants.padding),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(crossAxisCount: orientation == Orientation.portrait ? 2 : 4, childAspectRatio: 1.0, mainAxisSpacing: 0, crossAxisSpacing: Constants.padding, children: [
            CommandCard(
              tapped: () {
                AppAlertDialog.show(
                  context: context,
                  title: Strings.areYouSure,
                  subtitle: Strings.areYouSureContent,
                  buttonTitles: [Strings.cancel, Strings.yes],
                  buttonTap: (i) {
                    if (i == 1) {
                      for (var connection in context.read<ConnectionCubit>().activeConnections) {
                        cubit.sendCommand(
                          key: "shutdown",
                          value: null,
                          connection: connection,
                        );
                      }
                    }
                  },
                );
              },
              title: Strings.shutdown,
              icon: Images.shutdown,
            ),
            CommandCard(
              tapped: () {
                for (var connection in context.read<ConnectionCubit>().activeConnections) {
                  cubit.sendCommand(
                    key: "heading",
                    value: 0,
                    connection: connection,
                  );
                }
              },
              title: Strings.zeroHeading,
              icon: Images.north,
            ),
            CommandCard(
              tapped: () {
                context.router.push(
                  NoteCommandRoute(
                    devices: context.read<ConnectionCubit>().activeConnections.map((e) => e.device).toList(),
                  ),
                );
              },
              title: Strings.note,
              icon: Images.note,
            ),
          ]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommandCubit>(
      create: (context) => injector<CommandCubit>(),
      child: BlocConsumer<CommandCubit, CommandState>(
        listener: (context, state) {
          loadingNotifier.value = state is CommandSendingState;
        },
        builder: (context, state) {
          var cubit = context.read<CommandCubit>();
          return Scaffold(
            backgroundColor: Palette.backgroundLight,
            body: Stack(
              children: [
                _buildGrid(cubit),
                ValueListenableBuilder(
                  valueListenable: loadingNotifier,
                  builder: (context, loading, _) {
                    return AppLoader(show: loading);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
