import 'dart:io';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/petition_detail_model.dart';

class VideoViewController extends GetxController {
  VideoPlayerController? controller;

  RxBool initializedVideo = false.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    controller!.removeListener(_onVideoControllerUpdate);

    _disposeVideoController();
  }

  Future<void> xplayVideo({XFile? file, bool? isPlay = true}) async {
    isLoading.value = true;
    await _disposeVideoController();
    late VideoPlayerController _controller;
    _controller = VideoPlayerController.file(File(file!.path));
    controller = _controller;
    const double volume = 0.0;
    await _controller.setVolume(volume);
    await _controller.initialize();
    await _controller.setLooping(true);
    if (isPlay != null && isPlay) {
      await _controller.play();
    } else {
      initializedVideo.value = true;
    }
    controller!.addListener(_onVideoControllerUpdate);
    isLoading.value = false;
  }

  Future<void> playVideo({FileModel? file, bool? isPlay = true}) async {
    isLoading.value = true;
    var data = await IGateFilemanService().getOptionFile(id: file!.id ?? '');
    await _disposeVideoController();
    late VideoPlayerController _controller;
    _controller = VideoPlayerController.network(data['url'],
        httpHeaders: data['headers']);
    controller = _controller;
    const double volume = 0.0;
    await _controller.setVolume(volume);
    await _controller.initialize();
    await _controller.setLooping(true);
    if (isPlay != null && isPlay) {
      await _controller.play();
    } else {
      initializedVideo.value = true;
    }
    controller!.addListener(_onVideoControllerUpdate);
    isLoading.value = false;
  }

  Future<void> _disposeVideoController() async {
    controller = null;
  }

  void _onVideoControllerUpdate() {
    if (initializedVideo.value != controller!.value.isInitialized) {
      initializedVideo.value = controller!.value.isInitialized;
    }
  }
}
