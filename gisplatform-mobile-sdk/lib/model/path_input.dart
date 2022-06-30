import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/model/request_enums.dart';

class PathInput {
  final LatLng originPoint;
  final LatLng destPoint;
  final TravelMode travelMode;
  final AlgorithmType algorithmType;
  final WeightingType weightingType;

  PathInput({
    required this.originPoint,
    required this.destPoint,
    this.travelMode = TravelMode.car,
    this.algorithmType = AlgorithmType.astar_route,
    this.weightingType = WeightingType.fastest,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = _getPoints(originPoint, destPoint);
    data['vehical'] = _getTravelMode(travelMode);
    data['algorithm'] = _getAlgorithm(algorithmType);
    data['weighting'] = _getWeighting(weightingType);
    return data;
  }

  _getPoints(LatLng startP, LatLng endP) {
    String startPoint =
        startP.latitude.toString() + ',' + startP.longitude.toString();
    String endPoint =
        endP.latitude.toString() + ',' + endP.longitude.toString();
    return startPoint + ';' + endPoint;
  }

  _getTravelMode(TravelMode type) {
    String vehical = '';
    switch (type) {
      case TravelMode.walking:
        vehical = 'foot';
        break;
      case TravelMode.bike:
        vehical = 'bike';
        break;
      case TravelMode.car:
        vehical = 'car';
        break;
      case TravelMode.motorcycle:
        vehical = 'motorcycle';
        break;
      case TravelMode.water:
        vehical = 'water';
        break;
    }
    return vehical;
  }

  _getAlgorithm(AlgorithmType type) {
    String algorithm = '';
    switch (type) {
      case AlgorithmType.astar_route:
        algorithm = 'astar_route';
        break;
      case AlgorithmType.alternative_route:
        algorithm = 'alternative_route';
        break;
    }
    return algorithm;
  }

  _getWeighting(WeightingType type) {
    String weighting = '';
    switch (type) {
      case WeightingType.fastest:
        weighting = 'fastest';
        break;
    }
    return weighting;
  }
}
