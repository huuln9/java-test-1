import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_place/src/config/app_config.dart';

import 'hcm_place.dart';

class HCMPlaceMarker extends Marker {
  HCMPlaceMarker({this.place})
      : super(
            anchorPos: AnchorPos.align(AnchorAlign.top),
            point: LatLng(place!.latitude, place.longtitude),
            builder: (BuildContext context) => const Image(
                  image: AssetImage('${AppConfig.assetsRoot}/marker_v2.png'),
                  width: 36,
                  height: 36,
                ));

  final HCMPlaceResource? place;
}
