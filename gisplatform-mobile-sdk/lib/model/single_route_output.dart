import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/model/path_output.dart';

class SingleRouteOutput {
  SingleRouteOutput({
    required this.originPoint,
    required this.destPoint,
    this.points,
    this.instructions,

    /// met
    this.distance,

    /// miliseconds
    this.time,
  });
  final LatLng originPoint;
  final LatLng destPoint;
  final List<LatLng>? points;
  final List<Instructions>? instructions;
  final double? distance;
  final int? time;
}
