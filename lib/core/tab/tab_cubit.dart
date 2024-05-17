import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ximu3_app/core/api/ximu3_bindings.g.dart';
import 'package:ximu3_app/core/widgets/app_snack.dart';

import '../../features/connections/data/datasource/connections_datasource.dart';
import '../../features/connections/data/model/network_announcement_callback_result.dart';
import '../../features/connections/domain/usecases/add_network_announcement_usecase.dart';
import '../../features/connections/domain/usecases/remove_network_announcement_usecase.dart';
import '../utils/strings.dart';

abstract class TabState extends Equatable {
  const TabState();

  @override
  List<Object?> get props => [];
}

class TabInitialState extends TabState {}

class TabCubit extends Cubit<TabState> {
  final AddNetworkAnnouncementUseCase addNetworkAnnouncementUseCase;
  final RemoveNetworkAnnouncementUseCase removeNetworkAnnouncementUseCase;

  late TabController tabController;

  NetworkAnnouncementCallbackResult? networkAnnouncementCallbackResult;

  ValueNotifier<XIMU3_NetworkAnnouncementMessage?> networkAnnouncementNotifier =
      ValueNotifier(null);

  TabCubit({
    required this.addNetworkAnnouncementUseCase,
    required this.removeNetworkAnnouncementUseCase,
  }) : super(TabInitialState());

  void addNetworkAnnouncementCallback(BuildContext context) {
    final failOrSuccess =
        addNetworkAnnouncementUseCase.call(AddNetworkAnnouncementUseCaseParams(context));

    failOrSuccess.fold(
      (failure) {
        AppSnack.show(context, message: Strings.unableToOpen);
      },
      (data) {
        networkAnnouncementCallbackResult = data;
        print('Nework Announcement callback added: ${data?.callbackId}');
      },
    );

    ConnectionsAPI.instance.networkAnnouncementDataStream.listen((data) {
      // print(
      //     'Network announcement message: ${NetworkAnnouncementMessage.fromPointer(data).toString()}');

      networkAnnouncementNotifier.value = data;
      networkAnnouncementNotifier.notifyListeners();
    });
  }

  @override
  Future<void> close() {
    if (networkAnnouncementCallbackResult?.callbackId != null &&
        networkAnnouncementCallbackResult?.pointer != null) {
      removeNetworkAnnouncementUseCase.call(
        RemoveNetworkAnnouncementUseCaseParams(
          callbackId: networkAnnouncementCallbackResult!.callbackId,
          pointer: networkAnnouncementCallbackResult!.pointer,
        ),
      );
    }

    return super.close();
  }
}
