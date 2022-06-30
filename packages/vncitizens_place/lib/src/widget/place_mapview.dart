import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/hcm_place_marker.dart';
import 'package:vncitizens_place/src/widget/place_marker_no_data_popup.dart';
import 'package:vncitizens_place/src/widget/place_marker_popup.dart';

class PlaceMapView extends StatelessWidget {
  PlaceMapView({Key? key}) : super(key: key);

  final _controller = Get.put(PlaceController());
  final PopupController _popupLayerController = PopupController();

  // List<Marker> get _markers => _controller.places
  //     .map(
  //       (selector) => PlaceMarker(
  //         place: selector.data,
  //       ),
  //     )
  //     .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.hcmPlaces.isNotEmpty) {
            return FlutterMap(
              options: MapOptions(
                center: _controller.centerLocation.value,
                minZoom: 5,
                maxZoom: 21,
                zoom: 14,
              ),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                ),
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                      popupController: _popupLayerController,
                      markers: _controller.markers,
                      markerRotateAlignment:
                          PopupMarkerLayerOptions.rotationAlignmentFor(
                        AnchorAlign.top,
                      ),
                      popupBuilder: (BuildContext context, Marker marker) {
                        if (marker is HCMPlaceMarker) {
                          return PlaceMarkerPopup(marker);
                        } else {
                          return const PlaceMarkerNoDataPopup();
                        }
                      }),
                )
              ],
            );
          } else {
            return FlutterMap(
              options: MapOptions(
                center: AppConfig.centerLocation,
                minZoom: 5,
                maxZoom: 21,
                zoom: 14,
              ),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                ),
              ],
            );
          }
        }))
      ],
    );
  }
}
