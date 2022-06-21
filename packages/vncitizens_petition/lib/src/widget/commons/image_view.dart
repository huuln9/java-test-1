import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';

class ImageView extends StatelessWidget {
  const ImageView(this.file, {Key? key, this.saveCall}) : super(key: key);

  final dynamic file;
  final Function? saveCall;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phản ánh'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            height: Get.height,
            width: Get.width,
            child: Image.network(
              file!['url'],
              headers: file!['headers'],
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.download,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     if (saveCall != null) {
                  //       saveCall!();
                  //     }
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
