import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/maps/src/layer/tappable_polyline_layer.dart';

class LayerWidget<T> extends StatelessWidget {
  final T options;

  LayerWidget({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;

    /// Polyline
    if (options is PolylineLayerOptions) {
      return PolylineLayer(
        options as PolylineLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Tappable Popyline
    if (options is TappablePolylineLayerOptions) {
      return TappablePolylineLayer(
        options as TappablePolylineLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Polygon
    if (options is PolygonLayerOptions) {
      return PolygonLayer(
        options as PolygonLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// OverlayImage
    if (options is OverlayImageLayerOptions) {
      return OverlayImageLayer(
        options as OverlayImageLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Marker
    if (options is MarkerLayerOptions) {
      return MarkerLayer(
        options as MarkerLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Circle
    if (options is CircleLayerOptions) {
      return CircleLayer(
        options as CircleLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Group
    if (options is GroupLayerOptions) {
      return GroupLayer(
        options as GroupLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }

    /// Cluster
    if (options is MarkerClusterLayerOptions) {
      return MarkerClusterLayer(
        options as MarkerClusterLayerOptions,
        mapState,
        mapState.onMoved,
      );
    }
    return SizedBox();
  }

  static MarkerClusterLayerOptions getMarkerClusterLayerOptions({
    required List<Marker> markers,
    int maxClusterRadius = 120,
    Size size = const Size(40, 40),
    FitBoundsOptions? fitBoundsOptions,
    PolygonOptions? polygonOptions,
    Function(BuildContext, List<Marker>)? builder,
    Function(Marker)? onMarkerTap,
  }) {
    return MarkerClusterLayerOptions(
      maxClusterRadius: maxClusterRadius,
      size: size,
      fitBoundsOptions: fitBoundsOptions ??
          FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),

      /// Using List.from to update marker when changing
      markers: List.from(markers),
      polygonOptions: polygonOptions ??
          PolygonOptions(
            borderColor: Colors.blueAccent,
            color: Colors.black12,
            borderStrokeWidth: 3,
          ),
      builder: (context, markers) {
        return builder != null
            ? builder(context, markers)
            : FloatingActionButton(
                child: Text(markers.length.toString()),
                onPressed: null,
              );
      },
      onMarkerTap: onMarkerTap != null
          ? (Marker marker) {
              onMarkerTap(marker);
            }
          : null,
    );
  }

  static TappablePolylineLayerOptions getTappablePolylineLayerOptions({
    List<TaggedPolyline> polylines = const [],
    Function(List<TaggedPolyline>, TapUpDetails)? onTap,
    Function(TapUpDetails)? onMiss,
  }) {
    return TappablePolylineLayerOptions(
      polylineCulling: false,
      pointerDistanceTolerance: 20,
      polylines: polylines,
      onTap: (List<TaggedPolyline> taggedPolylines, TapUpDetails tapUpDetails) {
        print('===tappon ppolyline');
        if (onTap != null) {
          onTap(
            taggedPolylines,
            tapUpDetails,
          );
        }
      },
      onMiss: onMiss,
    );
  }
}
