import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';
import '../features/connections/presentation/bloc/connection_cubit.dart';
import 'tab/tab_cubit.dart';
import 'injection_container.dart' as di;

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;

  const GlobalBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TabCubit>(
          create: (context) => di.injector(),
        ),
        BlocProvider<ConnectionCubit>(
          create: (context) => di.injector(),
        ),
        BlocProvider<DataLoggerCubit>(
          create: (context) => di.injector(),
        ),
      ],
      child: child,
    );
  }
}
