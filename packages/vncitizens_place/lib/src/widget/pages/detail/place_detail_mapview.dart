import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/controller/place_detail_controller.dart';
import 'package:vncitizens_place/src/model/place_marker.dart';
import 'package:vncitizens_place/src/widget/commons/place_marker_no_data_popup.dart';
import 'package:vncitizens_place/src/widget/commons/place_marker_popup.dart';

import '../../../model/place_content.dart';

class PlaceDetailMapView extends StatelessWidget {
  PlaceDetailMapView({Key? key}) : super(key: key);

  final PlaceDetailController _controller = Get.put(PlaceDetailController());
  final PopupController _popupLayerController = PopupController();

  List<Marker> get _markers =>
      [PlaceMarker(place: PlaceContent.fromDetail(_controller.place.value))];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Obx(() {
          if (_controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 85),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return FlutterMap(
              options: MapOptions(
                center: _controller.centerLocation,
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
          }
        }))
      ],
    );
  }
}
