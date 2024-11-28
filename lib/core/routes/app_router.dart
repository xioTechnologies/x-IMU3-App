import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:ximu3_app/features/commands/presentation/pages/commands_page.dart';
import 'package:ximu3_app/features/connections/presentation/pages/connections_page.dart';
import 'package:ximu3_app/features/data_logger/presentation/pages/data_logger_name_page.dart';
import 'package:ximu3_app/features/device_settings/presentation/pages/device_settings_page.dart';
import 'package:ximu3_app/features/graphs/presentation/pages/graph_layout_page.dart';

import '../../features/commands/presentation/pages/note_command_page.dart';
import '../../features/connections/data/model/device.dart';
import '../../features/connections/presentation/pages/manual_connection_page.dart';
import '../../features/connections/presentation/pages/new_connection_page.dart';
import '../../features/data_logger/presentation/pages/data_logger_page.dart';
import '../../features/graphs/data/model/graph.dart';
import '../tab/tab.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TabRoute.page, initial: true),
    AutoRoute(page: ConnectionsRoute.page),
    AutoRoute(page: DataLoggerRoute.page),
    AutoRoute(page: DeviceSettingsRoute.page),
    AutoRoute(page: CommandsRoute.page),
    AutoRoute(page: NewConnectionRoute.page),
    AutoRoute(page: DataLoggerNameRoute.page),
    AutoRoute(page: GraphLayoutRoute.page),
    AutoRoute(page: NoteCommandRoute.page),
    AutoRoute(page: ManualConnectionRoute.page),
  ];
}
