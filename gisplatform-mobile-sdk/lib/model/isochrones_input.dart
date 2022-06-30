import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class IsochronesInput {
  String? vehical;
  LatLng? point;
  String? pointString;
  int? timeLimit;
  int? distanceLimit;
  String? type;

  IsochronesInput({
    this.vehical,
    this.point,
    this.timeLimit,
    this.distanceLimit,
    this.type,
  });

  IsochronesInput.fromJson(Map<String, dynamic> json) {
    vehical = json['vehical'];
    pointString = json['point'];
    timeLimit = json['time_limit'];
    distanceLimit = json['distance_limit'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehical'] = this.vehical;
    data['point'] = this.pointString;
    data['time_limit'] = this.timeLimit;
    data['distance_limit'] = this.distanceLimit;
    data['type'] = this.type;
    return data;
  }
}
