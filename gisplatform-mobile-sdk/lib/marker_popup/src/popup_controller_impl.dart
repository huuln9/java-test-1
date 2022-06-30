import 'dart:async';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vnpt_map/maps/vnpt_maps.dart';
import 'package:flutter_vnpt_map/marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_vnpt_map/marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_vnpt_map/marker_popup/src/popup_event.dart';
import 'package:latlong2/latlong.dart';
import 'popup_controller.dart';

class PopupControllerImpl implements PopupController {
  StreamController<PopupEvent>? streamController;

  /// The [MarkerWithKey]ss for which a popup is currently showing if there is
  /// one. This is for internal use.
  final Set<MarkerWithKey> selectedMarkersWithKeys;

  PopupControllerImpl({List<Marker> initiallySelectedMarkers = const []})
      : selectedMarkersWithKeys = LinkedHashSet.from(
          initiallySelectedMarkers.map(
            (marker) => MarkerWithKey(marker),
          ),
        );

  @override
  List<Marker> get selectedMarkers => selectedMarkersWithKeys
      .map((markerWithKey) => markerWithKey.marker)
      .toList();

  @override
  void showPopupsAlsoFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(PopupEvent.showAlsoFor(
      markers,
      disableAnimation: disableAnimation,
    ));
  }

  @override
  void showPopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(
      PopupEvent.showOnlyFor(markers, disableAnimation: disableAnimation),
    );
  }

  @override
  void hideAllPopups({bool disableAnimation = false}) {
    streamController?.add(
      PopupEvent.hideAll(disableAnimation: disableAnimation),
    );
  }

  @override
  void hidePopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(
      PopupEvent.hideOnlyFor(markers, disableAnimation: disableAnimation),
    );
  }

  @override
  void togglePopup(Marker marker, {bool disableAnimation = false}) {
    streamController?.add(PopupEvent.toggle(marker, disableAnimation: false));
  }

  @override
  void showPopupSimple(
    Marker? marker, {
    Widget? child,
    LatLng? point,
    bool disableAnimation = false,
  }) {
    streamController?.add(
      PopupEvent.showOnlyFor(
        marker != null
            ? <Marker>[marker]
            : <Marker>[
                Marker(
                  point: point ?? LatLng(0.0, 0.0),
                  width: 0.0,
                  height: 0.0,
                  builder: (context) => child ?? SizedBox(),
                  infoChild: child ?? SizedBox(),
                )
              ],
        disableAnimation: disableAnimation,
      ),
    );
  }
}
