import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_nature/src/model/nature_station_item_model.dart';

class InformationPopupNatureModel extends Marker {
  InformationPopupNatureModel(
  {
    required this.natureStationItemModel,
    required LatLng point,
    required WidgetBuilder builder,
    double? width,
    double? height
  }) : super(point: point, builder: builder, width: width ?? 30, height: height ?? 30);

  final NatureStationItemModel natureStationItemModel;
}