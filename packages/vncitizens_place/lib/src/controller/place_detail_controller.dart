import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/place_detail.dart';
import 'package:vncitizens_place/src/util/image_caching_util.dart';

class PlaceDetailController extends GetxController {
  late LatLng centerLocation;
  RxBool isLoading = false.obs;
  Rx<PlaceDetail> place = PlaceDetail().obs;

  Rxn<Uint8List> thumbnailBytes = Rxn<Uint8List>();

  @override
  void onInit() async {
    super.onInit();
    await _init();
    log("INIT PLACE DETAIL CONTROLLER", name: AppConfig.packageName);
  }

  Future<void> _init() async {
    PlaceController placeController = Get.find();
    _getPlaceById(placeController.id.value);
  }

  void _getPlaceById(String id) {
    try {
      isLoading(true);
      LocationService().getPlaceById(id: id).then((res) {
        place.value = PlaceDetail.fromJson(res.body);
        centerLocation = LatLng(place.value.location!.coordinates[1],
            place.value.location!.coordinates[0]);
        String thumbnailId = place.value.thumbnail;
        if (thumbnailId.isNotEmpty) {
          () async {
            await _getThumbnail(thumbnailId);
          }.call();
        } else {
          ImageCachingUtil.delete(thumbnailId);
        }
        isLoading(false);
      }, onError: (err) {
        isLoading(false);
      });
    } catch (ex) {
      isLoading(false);
    }
  }

  Future<void> _getThumbnail(String thumbnailId) async {
    Uint8List? thumbnail = await ImageCachingUtil.get(thumbnailId);
    if (thumbnail != null) {
      log("Load avatar from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      thumbnailBytes.value = thumbnail;
    } else {
      log("Load avatar from minio",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      Response responseFile =
          await StorageService().getFileDetail(id: thumbnailId);
      log(responseFile.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(responseFile.body.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
        File file =
            await MinioService().getFile(minioPath: responseFile.body["path"]);
        thumbnailBytes.value = await file.readAsBytes();
        ImageCachingUtil.set(thumbnailId, thumbnailBytes.value as Uint8List);
      }
    }
  }

  Future<void> makeCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    await launch(url).catchError((onError) {
      log('An error occurred ! Could not make a call',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Make a call successfully', name: AppConfig.packageName);
  }
}
