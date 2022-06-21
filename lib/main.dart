import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_template/src/core/app_init.dart';
import 'src/core/errors_handler.dart';
import 'src/widget/app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initApp();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppErrorHandler.onError(details: details);
      // exit(1);
    };
    runApp(const DigoApp());
  }, (Object error, StackTrace stack) {
    AppErrorHandler.onError(object: error, stack: stack);
    // exit(1);
  });
}
