import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ximu3_app/features/data_logger/data/model/session.model.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({
    Key? key,
    required this.session,
    this.onDelete,
    this.slidable = true,
  }) : super(key: key);

  final VoidCallback? onDelete;
  final Session session;
  final bool slidable;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.backgroundDark,
      child: ClipRRect(
        child: Stack(
          children: [
            Slidable(
              enabled: slidable,
              startActionPane: ActionPane(
                extentRatio: 0.15,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    padding: EdgeInsets.zero,
                    onPressed: (context) {
                      if (onDelete != null) {
                        onDelete!();
                      }
                    },
                    backgroundColor: Palette.backgroundLightest,
                    foregroundColor: Palette.white,
                    child: Utils.getSvgIcon(Images.bin),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: Constants.padding),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: AppText(
                    text: session.name,
                    weight: Weight.medium,
                  ),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: Utils.sessionDateFormat(session.date),
                      size: SizeFont.S,
                    ),
                    const SizedBox(width: Constants.padding),
                    AppText(
                      text: Utils.formatSize(session.size),
                      size: SizeFont.S,
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () async {
                    try {
                      await Utils.shareSession(session);
                    } catch (error) {
                      if (context.mounted) {
                        AppSnack.show(context, message: error.toString());
                      }
                    }
                  },
                  child: Icon(
                    Icons.adaptive.share,
                    color: Palette.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
