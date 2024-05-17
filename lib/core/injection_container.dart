import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ximu3_app/core/shared_preferences/shared_preferences_abstract.dart';
import 'package:ximu3_app/core/shared_preferences/shared_preferences_impl.dart';
import 'package:ximu3_app/features/commands/domain/repository/command_respository.dart';
import 'package:ximu3_app/features/commands/domain/usecases/read_command_usecase.dart';
import 'package:ximu3_app/features/commands/domain/usecases/write_command_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/new_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/new_manual_udp_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/add_network_announcement_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/remove_connection_usecase.dart';
import 'package:ximu3_app/features/connections/domain/usecases/remove_network_announcement_usecase.dart';
import 'package:ximu3_app/features/data_logger/domain/repository/data_logger_repository.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/create_session_usecase.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/get_sessions_usecase.dart';
import 'package:ximu3_app/features/data_logger/domain/usecases/stop_session_usecase.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';
import 'package:ximu3_app/features/device_settings/presentation/bloc/device_settings_cubit.dart';
import 'package:ximu3_app/features/graphs/presentation/bloc/graph_cubit.dart';

import '../features/commands/presentation/bloc/command_cubit.dart';
import '../features/connections/domain/repository/connections_repository.dart';
import '../features/connections/domain/usecases/get_available_connections_async_usecase.dart';
import '../features/connections/presentation/bloc/connection_cubit.dart';
import '../features/data_logger/domain/usecases/delete_session_usecase.dart';
import 'tab/tab_cubit.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector.registerFactory(() => SharedPreferences);
  final sharedPreferences = await SharedPreferences.getInstance();

  injector.registerLazySingleton<SharedPreferencesAbstract>(
    () => SharedPreferencesImpl(sharedPreferences: sharedPreferences),
  );

  //Cubits
  injector.registerFactory(
    () => TabCubit(
      addNetworkAnnouncementUseCase: injector(),
      removeNetworkAnnouncementUseCase: injector(),
    ),
  );

  injector.registerFactory(
    () => CommandCubit(
      sendCommandUseCase: injector(),
    ),
  );

  injector.registerFactory(
    () => ConnectionCubit(
      getAvailableConnectionsAsyncUseCase: injector(),
      removeConnectionUseCase: injector(),
      writeCommandUseCase: injector(),
      newConnectionUseCase: injector(),
      newManualUDPConnectionUseCase: injector(),
    ),
  );

  injector.registerFactory(
    () => DataLoggerCubit(
      createSessionUseCase: injector(),
      getSessionsUseCase: injector(),
      stopSessionUseCase: injector(),
      deleteSessionUseCase: injector(),
    ),
  );

  injector.registerFactory(
    () => GraphCubit(injector()),
  );

  injector.registerFactory(
    () => DeviceSettingsCubit(
      writeCommandUseCase: injector(),
      readCommandUseCase: injector(),
    ),
  );

  //Usecases
  injector.registerLazySingleton(() => WriteCommandUseCase(injector()));
  injector.registerLazySingleton(() => GetAvailableConnectionsAsyncUseCase(injector()));
  injector.registerLazySingleton(() => RemoveConnectionUseCase(injector()));
  injector.registerLazySingleton(() => GetSessionsUseCase(injector()));
  injector.registerLazySingleton(() => StopSessionUseCase(injector()));
  injector.registerLazySingleton(() => CreateSessionUseCase(injector()));
  injector.registerLazySingleton(() => DeleteSessionUseCase(injector()));
  injector.registerLazySingleton(() => AddNetworkAnnouncementUseCase(injector()));
  injector.registerLazySingleton(() => ReadCommandsUseCase(injector()));
  injector.registerLazySingleton(() => RemoveNetworkAnnouncementUseCase(injector()));
  injector.registerLazySingleton(() => NewConnectionUseCase(injector()));
  injector.registerLazySingleton(() => NewManualUDPConnectionUseCase(injector()));

  //Repositories
  injector.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(),
  );
  injector.registerLazySingleton<DataLoggerRepository>(
    () => DataLoggerRepositoryImpl(),
  );
  injector.registerLazySingleton<ConnectionsRepository>(
    () => ConnectionsRepositoryImpl(),
  );
}
