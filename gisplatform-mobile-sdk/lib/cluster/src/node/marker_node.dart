import 'package:flutter/widgets.dart';
import 'package:flutter_vnpt_map/cluster/src/node/marker_cluster_node.dart';
import 'package:flutter_vnpt_map/maps/vnpt_maps.dart';
import 'package:latlong2/latlong.dart';

class MarkerNode implements Marker {
  final Marker marker;
  MarkerClusterNode? parent;

  MarkerNode(this.marker);

  @override
  Key? get key => marker.key;

  @override
  Anchor get anchor => marker.anchor;

  @override
  WidgetBuilder get builder => marker.builder;

  @override
  double get height => marker.height;

  @override
  LatLng get point => marker.point;

  @override
  double get width => marker.width;

  @override
  bool? get rotate => marker.rotate;

  @override
  AlignmentGeometry? get rotateAlignment => marker.rotateAlignment;

  @override
  Offset? get rotateOrigin => marker.rotateOrigin;

  @override
  get data => marker.data;

  @override
  Widget? get infoChild => marker.infoChild;
}
