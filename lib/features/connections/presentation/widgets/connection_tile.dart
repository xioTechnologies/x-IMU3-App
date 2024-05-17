import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ximu3_app/features/connections/data/model/battery_status.dart';
import 'package:ximu3_app/features/connections/data/model/rssi_status.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/font_utils.dart';
import '../../../../core/utils/palette.dart';
import '../../../../core/utils/strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/connection.dart';
import '../../utils/connection_utils.dart';

class ConnectionTile extends StatelessWidget {
  const ConnectionTile({
    Key? key,
    required this.connection,
    this.onDelete,
    this.slidable = true,
    this.showIcons = true,
  }) : super(key: key);

  final VoidCallback? onDelete;
  final Connection connection;
  final bool slidable;
  final bool showIcons;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ConnectionCubit>();
    return Container(
      color: Palette.backgroundDark,
      child: ClipRRect(
        child: Stack(
          children: [
            Slidable(
              enabled: slidable,
              startActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const BehindMotion(),
                children: [
                  const SizedBox(width: 5),
                  CustomSlidableAction(
                    flex: 1,
                    padding: EdgeInsets.zero,
                    onPressed: (context) {
                      if (onDelete != null) {
                        onDelete!();
                      }
                    },
                    backgroundColor: Palette.backgroundLightest,
                    foregroundColor: Palette.white,
                    child: Utils.getSvgIcon(Images.bin),
                  ),
                  CustomSlidableAction(
                    padding: EdgeInsets.zero,
                    onPressed: (context) {
                      cubit.sendCommand(
                        key: "strobe",
                        value: null,
                        connection: connection,
                      );
                    },
                    backgroundColor: Palette.backgroundLightest,
                    foregroundColor: Palette.white,
                    child: Utils.getSvgIcon(Images.location),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    left:
                        slidable ? Constants.padding + Constants.indicatorWidth : Constants.padding,
                    right: Constants.padding),
                title: AppText(
                  text: "${connection.device.name} ${connection.device.serialNumber}",
                  weight: Weight.medium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "${connection.connectionInfo?.label}",
                      size: SizeFont.S,
                    ),
                    if (slidable)
                      StreamBuilder<String>(
                        stream: connection.statisticStream,
                        builder: (context, snapshot) {
                          return AppText(
                            text: "${snapshot.hasData ? snapshot.data : " "}",
                            size: SizeFont.S,
                          );
                        },
                      ),
                  ],
                ),
                trailing: showIcons
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<BatteryStatus>(
                            stream: connection.batteryStatusStream,
                            builder: (context, snapshot) {
                              return SvgPicture.asset(
                                ConnectionUtils.batteryIcon(snapshot.data, connection),
                                width: 22,
                              );
                            },
                          ),
                          const SizedBox(height: Constants.padding),
                          StreamBuilder<RssiStatus>(
                            stream: connection.rssiStatusStream,
                            builder: (context, snapshot) {
                              return SvgPicture.asset(
                                ConnectionUtils.wifiIcon(snapshot.data, connection),
                                width: 22,
                              );
                            },
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            if (slidable)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(color: connection.color, width: Constants.indicatorWidth),
              ),
          ],
        ),
      ),
    );
  }
}
