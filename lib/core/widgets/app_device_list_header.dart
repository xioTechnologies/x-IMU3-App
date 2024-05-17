import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/connections/data/model/connection.dart';
import '../../features/connections/presentation/bloc/connection_cubit.dart';
import '../utils/index.dart';
import 'app_text.dart';

class AppDeviceListHeader extends StatefulWidget {
  const AppDeviceListHeader({
    super.key,
    required this.connectionSelected,
  });

  final Function(Connection?) connectionSelected;

  @override
  State<AppDeviceListHeader> createState() => _AppDeviceListHeaderState();
}

class _AppDeviceListHeaderState extends State<AppDeviceListHeader> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ConnectionCubit>(),
      child: ValueListenableBuilder(
        valueListenable: context.read<ConnectionCubit>().activeConnectionsNotifier,
        builder: (context, List<Connection> connections, _) {
          var cubit = context.read<ConnectionCubit>();

          return Container(
            height: 35,
            color: Palette.backgroundDarkest,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                  connections.length,
                  (i) => InkWell(
                    onTap: () {
                      var connection = connections[i];
                      if (cubit.selectedConnection?.connectionInfo == connection.connectionInfo) {
                        return;
                      }
                      setState(() {
                        cubit.selectConnection(connection);
                      });
                      widget.connectionSelected(connection);
                    },
                    child: Row(
                      children: [
                        Container(width: Constants.indicatorWidth, color: connections[i].color),
                        const SizedBox(width: 5),
                        AppText(
                          text: connections[i].device.name,
                          size: SizeFont.S,
                          weight: Weight.medium,
                          color: cubit.selectedConnection?.connectionInfo ==
                                  connections[i].connectionInfo
                              ? Palette.white
                              : Palette.unselected,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
