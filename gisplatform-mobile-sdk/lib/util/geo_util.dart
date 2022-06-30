import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/dart_jts/dart_jts.dart' as jts;

class GeoUtil {
  bool isPointInPolygon(
    LatLng tap,
    List<LatLng> points,
  ) {
    int intersectCount = 0;
    for (int j = 0; j < points.length - 1; j++) {
      if (_rayCastIntersect(tap, points[j], points[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool _rayCastIntersect(
    LatLng tap,
    LatLng vertA,
    LatLng vertB,
  ) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }

  /// Cacutate Point list to draw a Polygon Buffer of a Point
  List<LatLng> getBufferPoint(LatLng position, double distanceInMeter) {
    final geometryFactory = jts.GeometryFactory.defaultPrecision();

    final point = geometryFactory
        .createPoint(jts.Coordinate(position.longitude, position.latitude));
    final buffer = point.buffer(distanceInMeter / 100000);
    final jts.Polygon jtsPolygon = buffer as jts.Polygon;
    return _getBufferPoints(jtsPolygon);
  }

  /// Cacutate Point list to draw a Polygon Buffer of a Polyline
  List<LatLng> getBufferPolyline(
      List<LatLng> polylinePoints, double distanceInMeter) {
    final geometryFactory = jts.GeometryFactory.defaultPrecision();

    List<jts.Coordinate> coords = polylinePoints
        .map((element) => jts.Coordinate(element.longitude, element.latitude))
        .toList();

    jts.LineString jtsPolyline = geometryFactory.createLineString(coords);

    jts.Polygon jtsPolygon =
        jtsPolyline.buffer(distanceInMeter / 100000) as jts.Polygon;

    return _getBufferPoints(jtsPolygon);
  }

  /// Cacutate Point list to draw a Polygon Buffer of a Polygon
  List<LatLng> getBufferPolygon(
      List<LatLng> polygonPoints, double distanceInMeter) {
    final geometryFactory = jts.GeometryFactory.defaultPrecision();

    List<jts.Coordinate> coords = polygonPoints
        .map((element) => jts.Coordinate(element.longitude, element.latitude))
        .toList();

    jts.LinearRing linearRing =
        jts.LinearRing.withFactory(coords, geometryFactory);

    jts.Polygon jtsPolygon = geometryFactory.createPolygon(linearRing, []);

    jtsPolygon = jtsPolygon.buffer(distanceInMeter / 100000) as jts.Polygon;

    return _getBufferPoints(jtsPolygon);
  }

  /// Return Point list from JTSPolygon
  List<LatLng> _getBufferPoints(jts.Polygon jtsPolygon) {
    final List<jts.Coordinate> jtsCoord = jtsPolygon.getCoordinates();
    List<LatLng> bufferPoints = [];
    jtsCoord.forEach((jts.Coordinate element) {
      bufferPoints.add(LatLng(element.y, element.x));
    });
    return bufferPoints;
  }
}
