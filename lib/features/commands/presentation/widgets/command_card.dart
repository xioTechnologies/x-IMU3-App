import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ximu3_app/features/commands/data/model/command_message.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/font_utils.dart';
import '../../../../core/widgets/app_text.dart';

class CommandCard extends StatelessWidget {
  const CommandCard({
    Key? key,
    required this.tapped,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final VoidCallback tapped;
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => tapped(),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    "${icon}",
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Constants.padding),
            AppText(
              text: "${title}",
              align: TextAlign.center,
              weight: Weight.medium,
            ),
          ],
        ),
      ),
    );
  }
}
