library flutter_vnpt_map;

export 'package:flutter_vnpt_map/geodesy/geodesy.dart';
export 'package:flutter_vnpt_map/model/index.dart';
export 'package:flutter_vnpt_map/util/index.dart';
export 'package:flutter_vnpt_map/widget/index.dart';
export 'package:flutter_vnpt_map/marker_popup/flutter_map_marker_popup.dart';
export 'package:flutter_vnpt_map/cluster/flutter_map_marker_cluster.dart';
export 'package:flutter_vnpt_map/net/map_service.dart';
export 'package:flutter_vnpt_map/util/enum/env.dart';
export 'package:flutter_vnpt_map/maps/vnpt_maps.dart';
export 'package:flutter_vnpt_map/maps/src/map/map.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/geodesy/geodesy.dart';
import 'package:flutter_vnpt_map/maps/vnpt_maps.dart';
import 'package:flutter_vnpt_map/maps/plugin_api.dart';
import 'package:flutter_vnpt_map/marker_popup/src/popup_controller_impl.dart';
import 'package:flutter_vnpt_map/net/map_service.dart';
import 'package:flutter_vnpt_map/marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_vnpt_map/util/enum/env.dart';
import 'package:flutter_vnpt_map/m_config.dart';
import 'package:flutter_vnpt_map/widget/index.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class VnptMaps {
  final MapService mapService = MapService();

  VnptMaps() {
    MConfig().setupEnv();
  }

  registerMapConfig(
    MapConfig mapConfig,
  ) {
    mapService.setMapConfig(
      mapConfig,
    );
  }

  /// Popup InfoWindow Marker
  PopupController _popupController = PopupControllerImpl();

  /// Update Popup InfoWindow Marker
  setPopupController(PopupController popupController) =>
      this._popupController = popupController;

  /// Get Popup InfoWindow Marker
  PopupController get _getPopupController => this._popupController;

  /// Init
  Widget onInit({
    Key? key,

    /// Animate map
    MapController? mapController,

    /// Hide all popup showed
    bool hideAllPopups = true,

    /// Scroll To Center
    bool scrollToCenter = false,

    /// Zoom value
    double? zoom,

    /// Position forcus
    LatLng? target,

    /// Marker list
    List<Marker> markers = const [],

    /// Layer Object Map
    Widget? layer,

    /// Tap on map
    Function(LatLng)? onMapTap,

    /// LongTap on map
    Function(LatLng)? onMapLongTap,
  }) {
    if (scrollToCenter && mapController == null) {
      throw ('To scrollToCenter, required init MapController!');
    }

    if (mapController == null) {
      mapController = MapController();
    }

    List<Widget> layers = <Widget>[
      TileLayerWidget(
        options: _getSimpleTileLayer(),
      ),
    ];

    if (layer != null) {
      layers.add(layer);
    }
    if (markers.isNotEmpty) {
      layers.add(
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            markers: markers,
            popupController: _getPopupController,
            popupBuilder: (_, Marker marker) {
              return marker.infoChild ??
                  InfoWindowView(
                    latlng: marker.point,
                  );
            },
          ),
        ),
      );
    }

    return FlutterMap(
      key: key,
      mapController: mapController,
      options: _getMapOptions(
        target: target,
        zoom: zoom ?? MConfig.ZOOM,
        onMapTap: (TapPosition tapPosition, LatLng point) {
          _hideAllPopupsIfNeed(
            hideAllPopups: hideAllPopups,
          );
          _checkAndScrollToCenterIfNeed(
            scrollToCenter: scrollToCenter,
            mapController: mapController,
            point: point,
          );
          if (onMapTap != null) {
            onMapTap(point);
          }
        },
        onMapLongTap: (tapPosition, point) {
          _hideAllPopupsIfNeed(
            hideAllPopups: hideAllPopups,
          );
          _checkAndScrollToCenterIfNeed(
            scrollToCenter: scrollToCenter,
            mapController: mapController,
            point: point,
          );
          if (onMapLongTap != null) {
            onMapLongTap(
              point,
            );
          }
        },
      ),
      children: layers,
    );
  }

  _hideAllPopupsIfNeed({
    required bool hideAllPopups,
  }) {
    try {
      if (hideAllPopups) _getPopupController.hideAllPopups();
    } catch (e) {}
  }

  _checkAndScrollToCenterIfNeed({
    required bool scrollToCenter,
    required MapController? mapController,
    required LatLng? point,
  }) {
    if (scrollToCenter && mapController != null && point != null) {
      try {
        mapController.move(
          point,
          mapController.zoom,
        );
      } catch (e) {}
    }
  }

  _getMapOptions({
    double zoom = 10,
    LatLng? target,
    TapCallback? onMapTap,
    TapCallback? onMapLongTap,
  }) {
    return MapOptions(
      center: target ?? MConfig.getInitLatLngPosition(),
      zoom: zoom,
      interactiveFlags: InteractiveFlag.all,
      onTap: onMapTap,
      onLongPress: onMapLongTap,
    );
  }

  TileLayerOptions _getSimpleTileLayer() {
    return TileLayerOptions(
      urlTemplate: MConfig().getBaseTiles(),
      subdomains: ['a', 'b', 'c'],
      tileProvider: NonCachingNetworkTileProvider(),
    );
  }

  getLatLng(
    double _latitude,
    double _longitude,
  ) {
    return LatLng(
      _latitude,
      _longitude,
    );
  }

  Widget getMarkerIcon() {
    return Icon(
      Icons.location_on,
      color: Colors.red,
      size: 40.0,
    );
  }

  showPopupInfoMarker({
    LatLng? withPoint,
    Marker? withMarker,
  }) {
    _popupController.showPopupsOnlyFor(
      <Marker>[
        withMarker ??
            Marker(
              point: withPoint!,
              width: 40.0,
              height: 40.0,
              builder: (_) => getMarkerIcon(),
              anchorPos: AnchorPos.align(
                AnchorAlign.top,
              ),
            ),
      ],
    );
  }
}

class MapConfig {
  MapConfig({
    required this.key,
    this.printLog = false,
    this.env = Env.prod,
  });
  final String key;
  final bool printLog;
  final Env env;
}
