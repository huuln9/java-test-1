import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class NotificationImageView extends StatelessWidget {
  const NotificationImageView({Key? key, required this.items, required this.index})
      : super(key: key);

  final List<Uint8List> items;
  final int index;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: index);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "chi tiet thong bao".tr,
            style: AppBarStyle.title,
          ),
          backgroundColor: Colors.blue.shade800,
        ),
        body: PhotoViewGallery.builder(
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: MemoryImage(items[index]),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            itemCount: items.length,
            pageController: _pageController));
  }
}
