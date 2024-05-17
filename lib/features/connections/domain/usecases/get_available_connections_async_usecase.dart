import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/data/model/connection.dart';
import '../../../../core/api/ximu3_bindings.g.dart';
import '../../../../core/usecase/failures.dart';
import '../repository/connections_repository.dart';

class GetAvailableConnectionsAsyncUseCase {
  ConnectionsRepository repository;

  GetAvailableConnectionsAsyncUseCase(this.repository);

  Future<Either<Failure, List<Connection>>> call(
      Pointer<XIMU3_NetworkAnnouncement>? networkAnnouncementPointer) async {
    return await repository.getAvailableConnectionsAsync(networkAnnouncementPointer);
  }
}
