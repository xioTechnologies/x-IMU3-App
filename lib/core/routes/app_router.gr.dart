// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CommandsPage]
class CommandsRoute extends PageRouteInfo<void> {
  const CommandsRoute({List<PageRouteInfo>? children})
      : super(CommandsRoute.name, initialChildren: children);

  static const String name = 'CommandsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CommandsPage();
    },
  );
}

/// generated route for
/// [ConnectionsPage]
class ConnectionsRoute extends PageRouteInfo<void> {
  const ConnectionsRoute({List<PageRouteInfo>? children})
      : super(ConnectionsRoute.name, initialChildren: children);

  static const String name = 'ConnectionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConnectionsPage();
    },
  );
}

/// generated route for
/// [DataLoggerNamePage]
class DataLoggerNameRoute extends PageRouteInfo<void> {
  const DataLoggerNameRoute({List<PageRouteInfo>? children})
      : super(DataLoggerNameRoute.name, initialChildren: children);

  static const String name = 'DataLoggerNameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DataLoggerNamePage();
    },
  );
}

/// generated route for
/// [DataLoggerPage]
class DataLoggerRoute extends PageRouteInfo<void> {
  const DataLoggerRoute({List<PageRouteInfo>? children})
      : super(DataLoggerRoute.name, initialChildren: children);

  static const String name = 'DataLoggerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DataLoggerPage();
    },
  );
}

/// generated route for
/// [DeviceSettingsPage]
class DeviceSettingsRoute extends PageRouteInfo<void> {
  const DeviceSettingsRoute({List<PageRouteInfo>? children})
      : super(DeviceSettingsRoute.name, initialChildren: children);

  static const String name = 'DeviceSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeviceSettingsPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GraphLayoutRouteArgs>();
      return GraphLayoutPage(
        key: args.key,
        toggleGraph: args.toggleGraph,
        graphs: args.graphs,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GraphLayoutRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(graphs, other.graphs);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(graphs);
}

/// generated route for
/// [NewConnectionPage]
class NewConnectionRoute extends PageRouteInfo<void> {
  const NewConnectionRoute({List<PageRouteInfo>? children})
      : super(NewConnectionRoute.name, initialChildren: children);

  static const String name = 'NewConnectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewConnectionPage();
    },
  );
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
          args: NoteCommandRouteArgs(key: key, devices: devices),
          initialChildren: children,
        );

  static const String name = 'NoteCommandRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteCommandRouteArgs>();
      return NoteCommandPage(key: args.key, devices: args.devices);
    },
  );
}

class NoteCommandRouteArgs {
  const NoteCommandRouteArgs({this.key, required this.devices});

  final Key? key;

  final List<Device> devices;

  @override
  String toString() {
    return 'NoteCommandRouteArgs{key: $key, devices: $devices}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NoteCommandRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(devices, other.devices);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(devices);
}

/// generated route for
/// [TabPage]
class TabRoute extends PageRouteInfo<void> {
  const TabRoute({List<PageRouteInfo>? children})
      : super(TabRoute.name, initialChildren: children);

  static const String name = 'TabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TabPage();
    },
  );
}
