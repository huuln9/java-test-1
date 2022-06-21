import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AvatarPreview extends StatelessWidget {
  const AvatarPreview({Key? key, required this.bytes}) : super(key: key);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Image.memory(bytes, fit: BoxFit.fitWidth,)),
              const SizedBox(height: 50),
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 140,
                  ),
                  child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white
                      ),
                      child: Text("dong".tr.toUpperCase(), style: const TextStyle(color: Colors.black),))),
            ],
          ),
        ),
      ),
    );
  }
}
