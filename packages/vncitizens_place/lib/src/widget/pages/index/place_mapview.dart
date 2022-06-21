import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/place_marker.dart';
import 'package:vncitizens_place/src/widget/commons/place_marker_no_data_popup.dart';
import 'package:vncitizens_place/src/widget/commons/place_marker_popup.dart';

class PlaceMapView extends StatelessWidget {
  PlaceMapView({Key? key}) : super(key: key);

  final _controller = Get.put(PlaceController());
  final PopupController _popupLayerController = PopupController();

  List<Marker> get _markers => _controller.places
      .map(
        (selector) => PlaceMarker(
          place: selector.data,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.places.isNotEmpty) {
            return FlutterMap(
              options: MapOptions(
                center: AppConfig.centerLocation,
                minZoom: 5,
                maxZoom: 24,
                zoom: 13,
              ),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    // urlTemplate:
                    //     'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    // subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                  ),
                ),
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                      popupController: _popupLayerController,
                      markers: _markers,
                      markerRotateAlignment:
                          PopupMarkerLayerOptions.rotationAlignmentFor(
                        AnchorAlign.top,
                      ),
                      popupBuilder: (BuildContext context, Marker marker) {
                        if (marker is PlaceMarker) {
                          return PlaceMarkerPopup(marker);
                        } else {
                          return const PlaceMarkerNoDataPopup();
                        }
                      }),
                ),
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
