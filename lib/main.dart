import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ximu3_app/core/global_bloc_provider.dart';

import 'core/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/utils/index.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await di.init();
      _configureErrorHandling();

      // if (Platform.isAndroid) {
      //   bool result = await releaseMulticast();
      //   print('Result: $result');
      // }

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const App());
      FlutterNativeSplash.remove();
    },
    (exception, stackTrace) {
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
        ),
        forceReport: true,
      );
      if (!kDebugMode) {
        //implement Sentry
      }
    },
  );
}

// Future<bool> releaseMulticast() async {
//   const MethodChannel channel = MethodChannel('com.ximu3.ximu3/multicastLock');
//
//   try {
//     final bool result = await channel.invokeMethod('releaseMulticastLock');
//     return result;
//   } on PlatformException catch (e) {
//     print("Failed to release multicast lock: '${e.message}'.");
//     return false;
//   }
// }

void _configureErrorHandling() {
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    if (!kDebugMode) {
      //implement Sentry
    }
  };
}

final appRouter = AppRouter();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

late BuildContext globalBuildContext;

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GlobalBlocProvider(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp.router(
          builder: (context, child) {
            globalBuildContext = context;
            return child!;
          },
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
          theme: ThemeData(
            primarySwatch: Palette.materialWhite,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
