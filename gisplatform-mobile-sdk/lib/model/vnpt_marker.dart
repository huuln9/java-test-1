import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class GroupMarker {
  GroupMarker({
    this.initLatlng,
    this.markers,
  });

  LatLng? initLatlng;
  List<VnptMarker>? markers;
}

class VnptMarker {
  VnptMarker({
    this.latlng,
    this.data,
  });

  LatLng? latlng;
  dynamic data;
}
