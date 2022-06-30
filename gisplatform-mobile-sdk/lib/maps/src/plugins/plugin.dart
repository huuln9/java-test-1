import 'package:flutter/widgets.dart';
import 'package:flutter_vnpt_map/maps/src/layer/layer.dart';
import 'package:flutter_vnpt_map/maps/src/map/map.dart';

abstract class MapPlugin {
  bool supportsLayer(LayerOptions options);
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream);
}
