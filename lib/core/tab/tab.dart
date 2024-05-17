import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/core/tab/tab_cubit.dart';
import 'package:ximu3_app/core/utils/palette.dart';
import 'package:ximu3_app/core/utils/utils.dart';
import 'package:ximu3_app/core/widgets/app_snack.dart';
import 'package:ximu3_app/features/commands/presentation/pages/commands_page.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/connections/presentation/pages/connections_page.dart';
import 'package:ximu3_app/features/data_logger/presentation/pages/data_logger_page.dart';
import 'package:ximu3_app/features/device_settings/presentation/pages/device_settings_page.dart';
import 'package:ximu3_app/features/graphs/presentation/pages/graphs_page.dart';

import '../../features/data_logger/presentation/bloc/data_logger_cubit.dart';
import '../utils/images.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';

class TabItem {
  String title;
  String icon;
  String? iconAlt;

  TabItem({
    required this.title,
    required this.icon,
    this.iconAlt,
  });
}

@RoutePage()
class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  List<TabItem> tabs = [
    TabItem(title: Strings.connections, icon: Images.search),
    TabItem(
        title: Strings.dataLogger, icon: Images.record, iconAlt: Images.stop),
    TabItem(title: Strings.graphs, icon: Images.windows),
    TabItem(title: Strings.deviceSettings, icon: Images.chip),
    TabItem(title: Strings.commands, icon: Images.json),
  ];

  int _selectedTabIndex = 0;

  bool _networkAnnouncementCallbackAdded = false;

  @override
  void initState() {
    super.initState();
    context.read<TabCubit>().tabController =
        TabController(length: tabs.length, vsync: this, animationDuration: Duration.zero);
    _tabController?.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (connectionCubit.activeConnections.isEmpty && _tabController?.index != 0) {
      AppSnack.show(context, message: Strings.noConnections);
      _tabController?.animateTo(0);
    }

    setState(() {
      _selectedTabIndex = _tabController?.index ?? 0;
    });
  }

  TabController? get _tabController {
    if (context.mounted) {
      return context.read<TabCubit>().tabController;
    }
    return null;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    context.read<TabCubit>().close();
    super.dispose();
  }

  ConnectionCubit get connectionCubit => context.read<ConnectionCubit>();

  String getIcon(int tabIndex, bool isRecording) {
    var tab = tabs[tabIndex];

    if (isRecording && tab.iconAlt != null) {
      return tab.iconAlt!;
    } else {
      return tab.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabCubit = context.read<TabCubit>();

    if (!_networkAnnouncementCallbackAdded) {
      _networkAnnouncementCallbackAdded = true;
      tabCubit.addNetworkAnnouncementCallback(context);
    }

    return ValueListenableBuilder(
      valueListenable: connectionCubit.activeConnectionsNotifier,
      builder: (context, connections, _) {
        return DefaultTabController(
          animationDuration: Duration.zero,
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Palette.backgroundLight,
            body: SafeArea(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: const [
                  ConnectionsPage(),
                  DataLoggerPage(),
                  GraphsPage(),
                  DeviceSettingsPage(),
                  CommandsPage(),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: Palette.backgroundDarkest,
              child: SafeArea(
                child: TabBar(
                  dividerHeight: 0,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  tabs: List.generate(
                    tabs.length,
                    (index) {
                      return Tab(
                        icon: Stack(
                          children: [
                            Opacity(
                              opacity: _selectedTabIndex == index ? 1.0 : Constants.opacity,
                              child: ValueListenableBuilder(
                                valueListenable: context.read<DataLoggerCubit>().recordingNotifier,
                                builder: (context, isRecording, _) {
                                  return Utils.getSvgIcon(
                                    getIcon(index, isRecording),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
