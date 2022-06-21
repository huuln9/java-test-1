import 'package:flutter/foundation.dart';

class CommonUtil {
  static String getCurrentClassAndFuncName(StackTrace stackTrace) {
    final List<StackFrame> currentFrames = StackFrame.fromStackTrace(stackTrace);
    return currentFrames.first.className + "." + currentFrames.first.method + " L:" + currentFrames.first.line.toString();
  }

  static String getCurrentFuncName(StackTrace stackTrace) {
    final List<StackFrame> currentFrames = StackFrame.fromStackTrace(stackTrace);
    return currentFrames.first.method;
  }
}