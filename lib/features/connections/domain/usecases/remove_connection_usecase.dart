import 'package:fpdart/fpdart.dart';
import 'package:ximu3_app/features/connections/data/model/connection.dart';
import 'package:ximu3_app/features/connections/domain/repository/connections_repository.dart';
import '../../../../core/usecase/failures.dart';
import '../../../../core/usecase/usecase_params.dart';
import '../../presentation/bloc/connection_cubit.dart';

class RemoveConnectionUseCase {
  ConnectionsRepository repository;

  RemoveConnectionUseCase(this.repository);

  Either<Failure, dynamic> call(RemoveConnectionUseCaseParams params) {
    return repository.removeConnection(params);
  }
}

class RemoveConnectionUseCaseParams extends BaseParams {
  final List<Connection> connections;
  final ConnectionCubit cubit;

  RemoveConnectionUseCaseParams({
    required this.connections,
    required this.cubit,
  });

  @override
  List<Object?> get props => [connections];
}
