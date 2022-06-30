import 'dart:convert';

import '../flutter_vnpt_map.dart';

class VnptMapUtils {
  ///decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  List<LatLng> decodeGeoEncoded(String encoded) {
    if (VnptMapUtils.isNullOrBlank(encoded)) {
      return <LatLng>[];
    }
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      final double latitude = (lat / 1E5).toDouble();
      final double longitude = (lng / 1E5).toDouble();
      LatLng p = new LatLng(latitude, longitude);
      poly.add(p);
    }
    return poly;
  }

  static SingleRouteOutput convertPath2Route(
    LatLng originPoint,
    LatLng destPoint,
    RPath rPath,
  ) {
    return SingleRouteOutput(
      originPoint: originPoint,
      destPoint: destPoint,
      points: VnptMapUtils().decodeGeoEncoded(rPath.geomEncoded!),
      instructions: rPath.instructions ?? [],
      distance: rPath.distance,
      time: rPath.time,
    );
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  static bool isNullOrBlank(String? input) {
    return input == null || input.trim().isEmpty;
  }

  static String convertStringPoint(LatLng point) {
    return '${point.latitude.toString()},${point.longitude.toString()}';
  }
}
