import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class IsochronesOutput {
  LatLng? orgPoint;
  List<LatLng>? pointsGeomEncoded;
  String? geomEncoded;
  List<Label>? labels;
  String? type;

  IsochronesOutput({
    this.orgPoint,
    this.pointsGeomEncoded,
    this.geomEncoded,
    this.labels,
    this.type,
  });
}
