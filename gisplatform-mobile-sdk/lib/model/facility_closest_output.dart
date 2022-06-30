import 'package:flutter_vnpt_map/model/path_output.dart';

class FacilityClosestOutput {
  String? label;
  double? lat;
  double? lon;
  String? address;
  List<RPath>? paths;

  FacilityClosestOutput({
    this.label,
    this.lat,
    this.lon,
    this.address,
    this.paths,
  });

  FacilityClosestOutput.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    lat = json['lat'];
    lon = json['lon'];
    address = json['address'];
    if (json['paths'] != null) {
      paths = <RPath>[];
      json['paths'].forEach((v) {
        paths!.add(new RPath.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['address'] = this.address;
    if (this.paths != null) {
      data['paths'] = this.paths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
