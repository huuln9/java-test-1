import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_camera/src/model/place_model.dart';

class CustomMarker extends Marker {
  CustomMarker({required this.camera, required LatLng point, required WidgetBuilder builder, double? width, double? height})
      : super(point: point, builder: builder, width: width ?? 30, height: height ?? 30);

  final PlaceModel camera;
}
