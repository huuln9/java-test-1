import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class NearbyOutput {
  String? geometry;
  String? geomEncoded;
  String? geomType;
  List<Label>? labels;
  List<LatLng>? points;

  NearbyOutput({
    this.geometry,
    this.geomEncoded,
    this.geomType,
    this.labels,
  });

  NearbyOutput.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
    geomEncoded = json['geom_encoded'];
    geomType = json['geom_type'];
    if (json['labels'] != null) {
      labels = <Label>[];
      json['labels'].forEach((v) {
        labels!.add(new Label.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geometry'] = this.geometry;
    data['geom_encoded'] = this.geomEncoded;
    data['geom_type'] = this.geomType;
    if (this.labels != null) {
      data['labels'] = this.labels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
