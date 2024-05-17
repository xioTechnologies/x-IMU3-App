import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/domain/repository/connections_repository.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';

class RemoveNetworkAnnouncementUseCase {
  ConnectionsRepository repository;

  RemoveNetworkAnnouncementUseCase(this.repository);

  Either<Failure, dynamic> call(RemoveNetworkAnnouncementUseCaseParams params) {
    return repository.removeNetworkAnnouncementCallback(params);
  }
}

class RemoveNetworkAnnouncementUseCaseParams extends BaseParams {
  final int callbackId;
  final Pointer<XIMU3_NetworkAnnouncement> pointer;

  RemoveNetworkAnnouncementUseCaseParams({
    required this.callbackId,
    required this.pointer,
  });

  @override
  List<Object?> get props => [callbackId, pointer];
}
