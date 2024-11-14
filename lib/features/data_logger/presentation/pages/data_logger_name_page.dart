import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/index.dart';
import '../../../../core/widgets/index.dart';

@RoutePage()
class DataLoggerNamePage extends StatefulWidget {
  const DataLoggerNamePage({super.key});

  @override
  State<DataLoggerNamePage> createState() => _DataLoggerNamePageState();
}

class _DataLoggerNamePageState extends State<DataLoggerNamePage> {
  late TextEditingController sessionNameController = TextEditingController();
  String sessionNamePlaceholder = 'Logged Data ${Utils.zipDateFormat(DateTime.now())}';

  @override
  void dispose() {
    sessionNameController.dispose();
    super.dispose();
  }

  get sessionName {
    if (sessionNameController.text.isNotEmpty) {
      return sessionNameController.text;
    } else {
      return sessionNamePlaceholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Strings.dataLogger),
      backgroundColor: Palette.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            AppTextField(
              controller: sessionNameController,
              label: Strings.sessionName,
              placeholder: sessionNamePlaceholder,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(Constants.padding),
          child: AppButton(
            buttonText: Strings.start,
            buttonTapped: () {
              context.router.popForced(sessionName);
            },
          ),
        ),
      ),
    );
  }
}
