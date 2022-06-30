import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/util/image_caching_util.dart';

import '../model/hcm_place.dart';
import '../model/hcm_place_marker.dart';

class PlaceDetailController extends GetxController {
  Rx<LatLng> centerLocation = AppConfig.centerLocation.obs;
  RxBool isLoading = false.obs;
  Rx<HCMPlaceResource> place = HCMPlaceResource().obs;
  HCMPlaceMarker? marker;

  Rxn<Uint8List> thumbnailBytes = Rxn<Uint8List>();
  bool placeDetailViewMap = AppConfig.getPlaceDetailViewMap;

  @override
  void onInit() async {
    super.onInit();
    await _init();
    log("INIT PLACE DETAIL CONTROLLER", name: AppConfig.packageName);
  }

  Future<void> _init() async {
    PlaceController placeController = Get.find();
    centerLocation.value = LatLng(placeController.hcmPlaceSelected!.latitude,
        placeController.hcmPlaceSelected!.longtitude);
    place.value = placeController.hcmPlaceSelected!;
    await _getHCMPlace(placeController);
  }

  Future<void> _getHCMPlace(PlaceController controller) async {
    try {
      var hcmPlaceSelected = controller.hcmPlaceSelected!;
      if (hcmPlaceSelected.latitude == 0.0 &&
          hcmPlaceSelected.longtitude == 0.0) {
        isLoading(true);

        var searchkey = '';
        var usingNewData = false;
        if (controller.hcmPlaceSelected!.address != null &&
            controller.hcmPlaceSelected!.address!.isNotEmpty &&
            controller.hcmPlaceSelected!.address != 'None') {
          searchkey = controller.hcmPlaceSelected!.address!;
        } else {
          usingNewData = true;
          searchkey = controller.hcmPlaceSelected!.name ?? '';
        }

        HCMLocationService().searchLocal(searchkey + ', Hồ Chí Minh').then(
            (value) {
          if (value.body['List'].length > 0) {
            var local = value.body['List'][0];
            if (!usingNewData) {
              controller.hcmPlaceSelected!.latitude = local['Latitude'];
              controller.hcmPlaceSelected!.longtitude = local['Longitude'];
              marker = HCMPlaceMarker(place: controller.hcmPlaceSelected);
              centerLocation.value = LatLng(
                  controller.hcmPlaceSelected!.latitude,
                  controller.hcmPlaceSelected!.longtitude);
              place.value = controller.hcmPlaceSelected!;
            } else {
              var pla = HCMPlaceResource.fromJson(value.body['List'][0]);
              marker = HCMPlaceMarker(place: pla);
              centerLocation.value = LatLng(pla.latitude, pla.longtitude);
              place.value = pla;
            }
          }

          isLoading(false);
        }, onError: (ex) {
          isLoading(false);
        });
      } else {
        marker = HCMPlaceMarker(place: controller.hcmPlaceSelected);
        centerLocation.value = LatLng(controller.hcmPlaceSelected!.latitude,
            controller.hcmPlaceSelected!.longtitude);
        place.value = controller.hcmPlaceSelected!;
      }
    } catch (ex) {
      isLoading(false);
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
