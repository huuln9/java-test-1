import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_place/src/model/place_content.dart';

class PlaceMarker extends Marker {
  PlaceMarker({required this.place})
      : super(
            anchorPos: AnchorPos.align(AnchorAlign.top),
            point: LatLng(
                place.location.coordinates[1], place.location.coordinates[0]),
            builder: (BuildContext context) => const Icon(
                  Icons.location_on,
                  size: 36,
                  color: Color(0xFF2F80ED),
                ));

  final PlaceContent place;
}
