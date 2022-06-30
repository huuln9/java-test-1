import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class PathOutput {
  List<RPath>? paths;

  PathOutput({this.paths});

  PathOutput.fromJson(Map<String, dynamic> json) {
    if (json['paths'] != null) {
      paths = <RPath>[];
      json['paths'].forEach((v) {
        paths!.add(new RPath.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paths != null) {
      data['paths'] = this.paths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RPath {
  double? distance;
  int? time;
  List<LatLng>? points;
  String? geomEncoded;
  List<Instructions>? instructions;

  RPath({
    this.distance,
    this.time,
    this.geomEncoded,
    this.instructions,
  });

  RPath.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    time = json['time'];
    points = _getPoints(json['geom_encoded']);
    geomEncoded = json['geom_encoded'];
    if (json['instructions'] != null) {
      instructions = <Instructions>[];
      json['instructions'].forEach((v) {
        instructions!.add(new Instructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['time'] = this.time;
    data['geom_encoded'] = this.geomEncoded;
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<LatLng> _getPoints(String geom) {
    if (geom.isEmpty) return [];
    return VnptMapUtils().decodeGeoEncoded(geom);
  }
}

class Geometry {
  String? type;

  Geometry({this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}

class Instructions {
  int? sign;
  double? distance;
  String? text;
  String? streetName;
  int? time;

  Instructions({
    this.sign,
    this.distance,
    this.text,
    this.streetName,
    this.time,
  });

  Instructions.fromJson(Map<String, dynamic> json) {
    sign = json['sign'];
    distance = json['distance'];
    text = json['text'];
    streetName = json['street_name'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sign'] = this.sign;
    data['distance'] = this.distance;
    data['text'] = this.text;
    data['street_name'] = this.streetName;
    data['time'] = this.time;
    return data;
  }
}
