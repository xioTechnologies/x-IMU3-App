// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CommandsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CommandsPage(),
      );
    },
    ConnectionsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ConnectionsPage(),
      );
    },
    DataLoggerNameRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DataLoggerNamePage(),
      );
    },
    DataLoggerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DataLoggerPage(),
      );
    },
    DeviceSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DeviceSettingsPage(),
      );
    },
    GraphLayoutRoute.name: (routeData) {
      final args = routeData.argsAs<GraphLayoutRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GraphLayoutPage(
          key: args.key,
          toggleGraph: args.toggleGraph,
          graphs: args.graphs,
        ),
      );
    },
    ManualConnectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ManualConnectionPage(),
      );
    },
    NewConnectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewConnectionPage(),
      );
    },
    NoteCommandRoute.name: (routeData) {
      final args = routeData.argsAs<NoteCommandRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteCommandPage(
          key: args.key,
          devices: args.devices,
        ),
      );
    },
    TabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabPage(),
      );
    },
  };
}

/// generated route for
/// [CommandsPage]
class CommandsRoute extends PageRouteInfo<void> {
  const CommandsRoute({List<PageRouteInfo>? children})
      : super(
          CommandsRoute.name,
          initialChildren: children,
        );

  static const String name = 'CommandsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ConnectionsPage]
class ConnectionsRoute extends PageRouteInfo<void> {
  const ConnectionsRoute({List<PageRouteInfo>? children})
      : super(
          ConnectionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConnectionsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataLoggerNamePage]
class DataLoggerNameRoute extends PageRouteInfo<void> {
  const DataLoggerNameRoute({List<PageRouteInfo>? children})
      : super(
          DataLoggerNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataLoggerNameRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataLoggerPage]
class DataLoggerRoute extends PageRouteInfo<void> {
  const DataLoggerRoute({List<PageRouteInfo>? children})
      : super(
          DataLoggerRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataLoggerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DeviceSettingsPage]
class DeviceSettingsRoute extends PageRouteInfo<void> {
  const DeviceSettingsRoute({List<PageRouteInfo>? children})
      : super(
          DeviceSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeviceSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GraphLayoutPage]
class GraphLayoutRoute extends PageRouteInfo<GraphLayoutRouteArgs> {
  GraphLayoutRoute({
    Key? key,
    required dynamic Function(Graph) toggleGraph,
    required List<Graph> graphs,
    List<PageRouteInfo>? children,
  }) : super(
          GraphLayoutRoute.name,
          args: GraphLayoutRouteArgs(
            key: key,
            toggleGraph: toggleGraph,
            graphs: graphs,
          ),
          initialChildren: children,
        );

  static const String name = 'GraphLayoutRoute';

  static const PageInfo<GraphLayoutRouteArgs> page =
      PageInfo<GraphLayoutRouteArgs>(name);
}

class GraphLayoutRouteArgs {
  const GraphLayoutRouteArgs({
    this.key,
    required this.toggleGraph,
    required this.graphs,
  });

  final Key? key;

  final dynamic Function(Graph) toggleGraph;

  final List<Graph> graphs;

  @override
  String toString() {
    return 'GraphLayoutRouteArgs{key: $key, toggleGraph: $toggleGraph, graphs: $graphs}';
  }
}

/// generated route for
/// [ManualConnectionPage]
class ManualConnectionRoute extends PageRouteInfo<void> {
  const ManualConnectionRoute({List<PageRouteInfo>? children})
      : super(
          ManualConnectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'ManualConnectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewConnectionPage]
class NewConnectionRoute extends PageRouteInfo<void> {
  const NewConnectionRoute({List<PageRouteInfo>? children})
      : super(
          NewConnectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewConnectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NoteCommandPage]
class NoteCommandRoute extends PageRouteInfo<NoteCommandRouteArgs> {
  NoteCommandRoute({
    Key? key,
    required List<Device> devices,
    List<PageRouteInfo>? children,
  }) : super(
          NoteCommandRoute.name,
          args: NoteCommandRouteArgs(
            key: key,
            devices: devices,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteCommandRoute';

  static const PageInfo<NoteCommandRouteArgs> page =
      PageInfo<NoteCommandRouteArgs>(name);
}

class NoteCommandRouteArgs {
  const NoteCommandRouteArgs({
    this.key,
    required this.devices,
  });

  final Key? key;

  final List<Device> devices;

  @override
  String toString() {
    return 'NoteCommandRouteArgs{key: $key, devices: $devices}';
  }
}

/// generated route for
/// [TabPage]
class TabRoute extends PageRouteInfo<void> {
  const TabRoute({List<PageRouteInfo>? children})
      : super(
          TabRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
