import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class MultiRouteOutput {
  MultiRouteOutput({
    required this.originPoint,
    required this.destPoint,
    required this.routes,
  });
  final LatLng originPoint;
  final LatLng destPoint;
  final List<SingleRouteOutput> routes;
}
