import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_petition/src/model/place_content.dart';

class PlaceMarker extends Marker {
  PlaceMarker({required this.place})
      : super(
            anchorPos: AnchorPos.align(AnchorAlign.top),
            point: LatLng(place.place!.latitude, place.place!.longitude),
            builder: (BuildContext context) => const Icon(
                  Icons.location_on,
                  size: 36,
                  color: Color(0xFF2F80ED),
                ));

  final PlaceContent place;
}
