import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ximu3_app/features/data_logger/presentation/bloc/data_logger_cubit.dart';
import 'package:ximu3_app/features/data_logger/presentation/widgets/session_tile.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';
import '../../data/model/session.model.dart';

class SessionsListView extends StatelessWidget {
  const SessionsListView({
    Key? key,
    required this.loading,
    required this.sessions,
    required this.cubit,
  }) : super(key: key);

  final bool loading;
  final List<Session>? sessions;
  final DataLoggerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: loading
          ? const AppLoader()
          : sessions == null
              ? Container()
              : SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  closeWhenTapped: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sessions!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var session = sessions![index];
                      return SessionTile(
                        onDelete: () {
                          cubit.deleteSession(name: session.name);
                        },
                        session: session,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: Constants.padding);
                    },
                  ),
                ),
    );
  }
}
