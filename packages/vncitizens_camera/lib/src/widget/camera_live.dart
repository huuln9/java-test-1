import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_camera/src/config/camera_app_config.dart';
import 'package:vncitizens_camera/src/controller/camera_live_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

import 'component/custom_marker_widget.dart';

class CameraLive extends GetView<CameraLiveController> {
  const CameraLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
      appBar: AppBar(
        title: const Text("Camera"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Obx(
                        () => controller.playerInitialized.value == false
                        ? const Center(child: CircularProgressIndicator())
                        : controller.playerError.value
                        ? ColoredBox(
                      color: const Color(0xFF090909),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "da co loi xay ra".tr + ".",
                                style: const TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                  onPressed: () => controller.initPlayer(),
                                  child: Text(
                                    "thu lai".tr,
                                    style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontWeight: FontWeight.w400),
                                  ))
                            ],
                          )
                      ),
                    )
                        : Chewie(controller: controller.chewieController!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
                  child: Text(
                    controller.cameraModel.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "dia chi".tr + ": " + controller.cleanAddress,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.w500, height: 1.7),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// show map if enabled
                if (CameraAppConfig.enableMap)
                  _buildMap(context),
              ],
            ),
          ),
          Obx(() => controller.hasConnected.value != true
            ? Container(color: Colors.white, child: NoInternet(onPressed: () {}))
            : const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 300,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.width,
      ),
      child: FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          center: controller.cameraModel.location.coordinates[1] != null && controller.cameraModel.location.coordinates[0] != null
              ? LatLng(controller.cameraModel.location.coordinates[1]!, controller.cameraModel.location.coordinates[0]!)
              : LatLng(CameraAppConfig.defaultLatitude, CameraAppConfig.defaultLongitude),
          zoom: 15,
          minZoom: 5,
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
              popupBuilder: (BuildContext context, Marker marker) =>
                  _buildPopup(context, controller.cameraModel.name, controller.cleanAddress),
              markers: controller.cameraModel.location.coordinates[1] != null && controller.cameraModel.location.coordinates[0] != null
                  ? [
                      Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(controller.cameraModel.location.coordinates[1]!, controller.cameraModel.location.coordinates[0]!),
                          builder: (_) => const CustomMarkerWidget())
                    ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopup(BuildContext context, String name, String address) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8
      ),
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(child: Text(address, style: const TextStyle(height: 1.2))),
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
