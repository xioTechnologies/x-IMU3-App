import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/data/model/network_announcement_callback_result.dart';
import 'package:ximu3_app/features/connections/domain/repository/connections_repository.dart';

import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';

class AddNetworkAnnouncementUseCase {
  ConnectionsRepository repository;

  AddNetworkAnnouncementUseCase(this.repository);

  Either<Failure, NetworkAnnouncementCallbackResult?> call(
      AddNetworkAnnouncementUseCaseParams params) {
    return repository.addNetworkAnnouncementCallback(params);
  }
}

class AddNetworkAnnouncementUseCaseParams extends BaseParams {
  final BuildContext context;

  AddNetworkAnnouncementUseCaseParams(this.context);

  @override
  List<Object?> get props => [context];
}
