import 'package:flutter/foundation.dart';
import 'dart:async';

class DebounceUtil {
  final int milliseconds;
  Timer? _timer;

  DebounceUtil({
    required this.milliseconds,
  });

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
