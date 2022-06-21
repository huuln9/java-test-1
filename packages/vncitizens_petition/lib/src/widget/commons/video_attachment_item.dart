import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_detail_controller.dart';
import 'package:vncitizens_petition/src/controller/video_view_controller.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';
import 'package:vncitizens_petition/src/util/helpers_download.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class VideoAttachmentItem extends StatefulWidget {
  const VideoAttachmentItem({Key? key, this.file, this.onTap})
      : super(key: key);

  final FileModel? file;
  final VoidCallback? onTap;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<VideoAttachmentItem> {
  final VideoViewController _controller = VideoViewController();
  final PetitionDetailController _controllerDetail =
      Get.put(PetitionDetailController());

  @override
  void initState() {
    super.initState();
    // if (widget.file != null) {
    //   _controller.playVideo(file: widget.file!, isPlay: false);
    // }
    if (widget.file != null && widget.file!.id != null) {
      _controller.playVideo(file: widget.file!, isPlay: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List?> getThumbnail() async {
    try {
      var imageUint8list = await VideoThumbnail.thumbnailData(
        video: widget.file!.path ?? '',
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            200, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );
      return imageUint8list;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.file != null && widget.file!.path != null
        ? FutureBuilder<Uint8List?>(
            future: getThumbnail(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Stack(
                  children: [
                    Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage(
                            '${AppConfig.assetsRoot}/youtube-play.png'),
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            })
        : Obx(() {
            if (_controller.controller != null &&
                _controller.initializedVideo.value) {
              return InkWell(
                onTap:
                    !_controllerDetail.fileDownloading.contains(widget.file!.id)
                        ? widget.onTap
                        : null,
                child: Stack(
                  children: [
                    VideoPlayer(_controller.controller!),
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() {
                        if (_controllerDetail.fileDownloading
                            .contains(widget.file!.id)) {
                          return Center(
                              child: StreamBuilder<double>(
                                  stream: HelperDownload()
                                      .getProgressStream(widget.file!),
                                  builder: (context, snapshot) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      value: snapshot.data,
                                    ));
                                  }));
                        }
                        return const Image(
                          image: AssetImage(
                              '${AppConfig.assetsRoot}/youtube-play.png'),
                          width: 50,
                          fit: BoxFit.cover,
                        );
                      }),
                    )
                  ],
                ),
              );
            } else {
              return _controller.isLoading.value
                  ? const Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(child: CircularProgressIndicator())),
                    )
                  : Container();
            }
          });

    // if (initialized) {
    //   return Center(
    //     child: AspectRatio(
    //       aspectRatio: _controller!.value.aspectRatio,
    //       child: VideoPlayer(_controller!),
    //     ),
    //   );
    // } else {
    //   return Container();
    // }
  }
}
