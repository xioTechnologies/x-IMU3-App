import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ximu3_app/features/connections/presentation/bloc/connection_cubit.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_state.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/session.model.dart';
import '../widgets/duration_field.dart';
import '../widgets/sessions_listview.dart';
import '../widgets/storage_label.dart';

@RoutePage()
class DataLoggerPage extends StatefulWidget {
  const DataLoggerPage({super.key});

  @override
  State<DataLoggerPage> createState() => _DataLoggerPageState();
}

class _DataLoggerPageState extends State<DataLoggerPage>
    with AutomaticKeepAliveClientMixin<DataLoggerPage> {
  ValueNotifier<bool> loading = ValueNotifier(true);

  late DateTime sessionStartDate = DateTime.now();

  ValueNotifier<String?> storageUsageLabel = ValueNotifier('');

  ValueNotifier<String> searchNotifier = ValueNotifier('');

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setStorageUsedLabel();
  }

  void setStorageUsedLabel() async {
    storageUsageLabel.value = await Utils.calculateStorageUsage();
  }

  void startTimer(DataLoggerCubit cubit) {
    sessionStartDate = DateTime.now();
    cubit.timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final now = DateTime.now();
      final elapsed = now.difference(sessionStartDate);
      cubit.timerNotifier.value = Utils.formatDuration(elapsed);
    });
  }

  List<Session> filteredSessions(List<Session> sessions) {
    if (sessions.isNotEmpty) {
      return sessions
          .where((s) => s.name.toLowerCase().contains(searchNotifier.value.toLowerCase()))
          .toList();
    }
    return [];
  }

  _scaffold(DataLoggerCubit cubit, {List<Session>? sessions, bool loading = false}) {
    return Scaffold(
      backgroundColor: Palette.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                    valueListenable: cubit.recordingNotifier,
                    builder: (context, recording, _) {
                      return InkWell(
                        onTap: () async {
                          if (!recording) {
                            var result = await context.router.push(const DataLoggerNameRoute());

                            if (result != null && result is String && context.mounted) {
                              cubit.sessionName = result;

                              cubit.createSession(
                                connections: context.read<ConnectionCubit>().activeConnections,
                              );
                            }
                          } else {
                            cubit.stopSession();
                          }
                        },
                        child: SvgPicture.asset(
                          recording ? Images.stop : Images.record,
                          width: 50,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: Constants.padding),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: cubit.timerNotifier,
                      builder: (context, elapsed, _) {
                        return DurationDisplay(duration: elapsed);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: Constants.padding),
                StorageLabel(label: storageUsageLabel),
                const SizedBox(height: Constants.padding),
                if ((sessions ?? []).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Constants.padding),
                    child: ValueListenableBuilder(
                      valueListenable: searchNotifier,
                      builder: (context, searchTerm, _) {
                        return AppSearchBarFilter(
                          hintText: Strings.search,
                          value: searchTerm,
                          onEnter: (str) {},
                          onType: (str) {
                            searchNotifier.value = str;
                          },
                          showFilter: false,
                          onCancel: () {
                            searchNotifier.value = "";
                          },
                          filterTapped: () {},
                        );
                      },
                    ),
                  ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: searchNotifier,
              builder: (context, searchTerm, _) {
                return SessionsListView(
                  loading: loading,
                  sessions: filteredSessions(sessions ?? []),
                  cubit: cubit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: context.read<DataLoggerCubit>()..getSessions(),
      child: BlocConsumer<DataLoggerCubit, DataLoggerState>(
        listener: (context, state) {
          var cubit = context.read<DataLoggerCubit>();

          loading.value = state is CreatingSessionState || state is DeletingSessionState;

          if (state is CreateSessionErrorState) {
            AppSnack.show(context, message: state.message);
          }

          if (state is DeleteSessionErrorState) {
            AppSnack.show(context, message: state.message);
          }

          if (state is StopSessionErrorState) {
            AppSnack.show(context, message: state.message);
          }

          if (state is CreateSessionSuccessState) {
            sessionStartDate = DateTime.now();
            startTimer(cubit);
          }

          if (state is StopSessionSuccessState) {
            context.read<DataLoggerCubit>().getSessions();
            setStorageUsedLabel();
          }

          if (state is DeleteSessionSuccessState) {
            context.read<DataLoggerCubit>().getSessions();
            setStorageUsedLabel();
          }
        },
        buildWhen: (context, state) =>
            state is FetchingSessionsState ||
            state is FetchSessionsSuccessState ||
            state is FetchSessionsErrorState,
        builder: (context, state) {
          var cubit = context.read<DataLoggerCubit>();

          if (state is FetchingSessionsState) {
            return _scaffold(cubit, loading: true);
          } else if (state is FetchSessionsSuccessState) {
            return _scaffold(cubit, sessions: state.sessions);
          } else {
            return _scaffold(cubit);
          }
        },
      ),
    );
  }
}
