import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

initAppErrorHandler() async {
  dev.log("initialize error handler", name: AppConfig.packageName);
}

class AppErrorHandler {
  static onError({FlutterErrorDetails? details, StackTrace? stack, Object? object}) {
    dev.log("an error has occurs", name: AppConfig.packageName);
    if (details != null) {
      dev.log("error details: " + details.toString(), name: AppConfig.packageName);
    }
    if (stack != null) {
      dev.log("error stack: " + stack.toString(), name: AppConfig.packageName);
    }
    if (object != null) {
      dev.log("error class: " + object.runtimeType.toString(), name: AppConfig.packageName);
      dev.log("error object: " + object.toString(), name: AppConfig.packageName);
    }
  }
}
