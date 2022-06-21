import 'dart:developer' as dev;
import 'package:chewie/chewie.dart';
import 'package:vncitizens_camera/src/model/place_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class CameraLiveController extends GetxController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final mapController = MapController();
  final popupController = PopupController();
  RxBool playerInitialized = false.obs;
  late PlaceModel cameraModel;
  String cleanAddress = "";
  RxBool playerError = false.obs;
  RxBool hasConnected = Get.find<InternetController>().hasConnected;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    /// check camera model passed
    if (Get.arguments[0] != null && Get.arguments[0] is PlaceModel) {
      cameraModel = Get.arguments[0];
    }  else {
      throw "No camera model passed";
    }
    setCleanAddress();
    initPlayer();

    hasConnected.listen((bool value) {
      if (value == true) {
        initPlayer();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    if (videoPlayerController != null) {
      videoPlayerController?.dispose();
    }
    if (chewieController != null) {
      chewieController?.dispose();
    }
  }

  // ========== MANUAL FUNC ==========
  void setCleanAddress() {
    List<String?> addressArr = [cameraModel.address, cameraModel.fullPlace]..removeWhere((element) => element == null || element.isEmpty);
    cleanAddress = addressArr.join(" - ");
  }

  Future<void> initPlayer() async {
    playerError.value = false;
    playerInitialized.value = false;
    await Future.delayed(const Duration(milliseconds: 300));
    if (cameraModel.url != null) {
      videoPlayerController = VideoPlayerController.network(cameraModel.url!);
      dev.log("Initializing url: " + cameraModel.url!, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      await videoPlayerController!.initialize().catchError((error) async {
        dev.log("Lỗi không thể phát video", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        dev.log(videoPlayerController!.value.isInitialized.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        playerError.value = true;
      });
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        showOptions: false,
        allowMuting: false,
        isLive: true,
      );
      playerInitialized.value = true;
    }
  }
}