import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_camera/src/controller/camera_map_controller.dart';
import 'package:vncitizens_camera/src/model/custom_marker.dart';
import 'package:vncitizens_camera/src/model/place_model.dart';
import 'package:vncitizens_camera/src/widget/component/api_error_widget.dart';
import 'package:vncitizens_camera/src/widget/component/custom_marker_widget.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

import 'component/linear_loading_widget.dart';

class CameraMap extends GetView<CameraMapController> {
  const CameraMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
        Get.back(result: controller.searchController.text);
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const MyBottomAppBar(index: -1),
          appBar: AppBar(
            title: Obx(() => !controller.isShowSearchInput.value
                ? const Text("Camera")
                : _SearchInput(controller: controller)),
            actions: [
              Obx(() => controller.isShowSearchInput.value
                  ? IconButton(onPressed: () => controller.onClickSearchDeleteIcon(), icon: const Icon(Icons.close))
                  : IconButton(onPressed: () => controller.onTapIconSearch(), icon: const Icon(Icons.search))),
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.list_outlined))
            ],
          ),
          body: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
                children: [
                  _buildMap(),
                  Obx(
                        () => controller.hasConnected.value != true
                        ? Positioned.fill(child: Container(color: Colors.white, child: NoInternet(onPressed: () {})))
                        : const SizedBox(),
                  ),
                  Obx(
                    () => controller.hasConnected.value && !controller.isInitialized.value
                        ? Positioned.fill(
                            child: Container(
                              color: Colors.white,
                              child: const LinearLoadingWidget(),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => controller.hasConnected.value && controller.isSearching.value
                        ? Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const LinearLoadingWidget(background: Colors.white),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => controller.hasConnected.value && controller.isInitialized.value && controller.isInitError.value
                        ? Positioned.fill(child: Container(color: Colors.white, child: ApiErrorWidget(retry: () => controller.init())))
                        : const SizedBox(),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Obx(
      () => FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          zoom: controller.defaultZoom,
          minZoom: 1,
          maxZoom: 17,
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              popupController: controller.popupController,
              markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
              popupBuilder: (BuildContext context, Marker marker) {
                if (marker is CustomMarker) {
                  return _buildPopupCustomMarker(context, marker);
                }
                return const SizedBox();
              },
              markers: _getListMarker(controller.cameraModels),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _getListMarker(List<PlaceModel> models) {
    List<Marker> lst = [];
    models.removeWhere((element) => element.location.coordinates.isEmpty || element.location.coordinates.first == null);
    if (models.isEmpty) {
      return [];
    }
    for (var element in models) {
      lst.add(CustomMarker(
        point: LatLng(element.location.coordinates[1]!, element.location.coordinates[0]!),
        width: 40,
        height: 40,
        camera: element,
        builder: (_) => const CustomMarkerWidget(),
      ));
    }
    return lst;
  }

  Widget _buildPopupCustomMarker(BuildContext context, CustomMarker marker) {
    List<String?> addressArr = [marker.camera.address, marker.camera.fullPlace]
      ..removeWhere((element) => element == null || element.isEmpty);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      child: Card(
        child: InkWell(
          onTap: () => controller.onTapLocationPopup(marker.camera),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(marker.camera.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(child: Text(addressArr.join(" - "), style: const TextStyle(height: 1.2))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({Key? key, required this.controller}) : super(key: key);

  final CameraMapController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller.searchController,
      onChanged: (value) => controller.onChangeSearch(value),
      onEditingComplete: () => controller.onSearchComplete(),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        hintText: "nhap dia diem".tr,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}