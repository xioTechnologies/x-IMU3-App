import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../../connections/presentation/bloc/connection_cubit.dart';
import '../bloc/connection_state.dart';

@RoutePage()
class ManualConnectionPage extends StatefulWidget {
  const ManualConnectionPage({
    super.key,
  });

  @override
  State<ManualConnectionPage> createState() => _ManualConnectionPageState();
}

class _ManualConnectionPageState extends State<ManualConnectionPage> {
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController ipAddressController = TextEditingController();
  TextEditingController sendPortController = TextEditingController();
  TextEditingController receivePortController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ConnectionCubit>(),
      child: BlocConsumer<ConnectionCubit, ConnectionsState>(
        listener: (context, state) {
          if (state is ManualConnectSuccessState) {
            context.read<ConnectionCubit>().selectConnection(state.connection);
            context.router.popForced();
          }

          if (state is ConnectErrorState) {
            AppSnack.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(title: Strings.newUdpConnection),
            backgroundColor: Palette.backgroundLight,
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(Constants.padding),
              color: Palette.backgroundLight,
              child: SafeArea(
                child: ValueListenableBuilder(
                  valueListenable: context.read<ConnectionCubit>().connectingNotifier,
                  builder: (context, connecting, _) {
                    return AppButton(
                      buttonText: Strings.connect,
                      enabled: !connecting,
                      loading: connecting,
                      buttonTapped: () {
                        if (ipAddressController.text.isEmpty ||
                            sendPortController.text.isEmpty ||
                            receivePortController.text.isEmpty) {
                          return;
                        }

                        context.read<ConnectionCubit>().newManualUDPConnection(
                              ipAddressController.text,
                              sendPortController.text,
                              receivePortController.text,
                            );
                      },
                    );
                  },
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Constants.padding),
              child: Column(
                children: [
                  AppTextField(
                    label: Strings.ipAddress,
                    controller: ipAddressController,
                    onChanged: (str) {},
                  ),
                  const SizedBox(height: Constants.padding),
                  AppTextField(
                    label: Strings.sendPort,
                    controller: sendPortController,
                    onChanged: (str) {},
                  ),
                  const SizedBox(height: Constants.padding),
                  AppTextField(
                    label: Strings.receivePort,
                    controller: receivePortController,
                    onChanged: (str) {},
                  ),
                  const SizedBox(height: Constants.padding),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
