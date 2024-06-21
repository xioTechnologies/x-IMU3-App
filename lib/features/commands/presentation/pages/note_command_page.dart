import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/features/commands/data/model/command_message.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../../connections/data/model/device.dart';
import '../../../connections/presentation/bloc/connection_cubit.dart';
import '../bloc/command_cubit.dart';
import '../bloc/command_state.dart';

@RoutePage()
class NoteCommandPage extends StatefulWidget {
  const NoteCommandPage({
    super.key,
    required this.devices,
  });

  final List<Device> devices;

  @override
  State<NoteCommandPage> createState() => _NoteCommandPageState();
}

class _NoteCommandPageState extends State<NoteCommandPage> {
  TextEditingController noteController = TextEditingController();
  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommandCubit>(
      create: (context) => injector<CommandCubit>(),
      child: BlocConsumer<CommandCubit, CommandState>(
        listener: (context, state) {
          loadingNotifier.value = state is! CommandSendingState;

          if (state is CommandSentState) {
            context.router.pop();
          }
        },
        builder: (context, state) {
          var cubit = context.read<CommandCubit>();
          List<String> recentNotes = cubit.getRecentNotes();

          return Scaffold(
            appBar: const CustomAppBar(title: Strings.note),
            backgroundColor: Palette.backgroundLight,
            bottomNavigationBar: MultiValueListenableBuilder<bool, bool>(
              listenableA: loadingNotifier,
              listenableB: buttonEnabledNotifier,
              builder: (context, loading, enabled, _) {
                return Container(
                  padding: const EdgeInsets.all(Constants.padding),
                  color: Palette.backgroundLight,
                  child: SafeArea(
                    child: AppButton(
                      buttonText: Strings.send,
                      buttonTapped: () {
                        for (var connection in context.read<ConnectionCubit>().activeConnections) {
                          cubit.sendCommand(
                            key: "note",
                            value: noteController.text,
                            connection: connection,
                          );
                        }

                        cubit.addToRecentNotes(noteController.text);
                      },
                      enabled: enabled && !loading,
                      loading: loading,
                    ),
                  ),
                );
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(Constants.padding),
              child: Column(
                children: [
                  AppTextField(
                    label: Strings.note,
                    controller: noteController,
                    onChanged: (str) {
                      buttonEnabledNotifier.value = str.isNotEmpty;
                    },
                  ),
                  const SizedBox(height: Constants.padding),
                  Expanded(
                    child: ListView.separated(
                      itemCount: recentNotes.length,
                      itemBuilder: (context, index) {
                        var note = recentNotes[index];
                        return Container(
                          color: Palette.backgroundDark,
                          child: ListTile(
                            title: AppText(text: note),
                            onTap: () {
                              noteController.text = note;
                              buttonEnabledNotifier.value = true;
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: Constants.padding);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
