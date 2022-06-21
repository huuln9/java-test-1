import 'dart:typed_data';

import 'package:flutter/material.dart';

class TestImage extends StatelessWidget {
  const TestImage({Key? key, required this.bytes}) : super(key: key);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("test"),
            centerTitle: true
        ),
        body: Image.memory(bytes)
        );
  }
}
