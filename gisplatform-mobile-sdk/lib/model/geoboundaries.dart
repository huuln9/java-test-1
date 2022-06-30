import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class Geoboundaries {
  String? name;
  String? type;
  String? id;
  String? geomEncoded;
  String? geomType;
  List<LatLng>? points;

  Geoboundaries({
    this.name,
    this.type,
    this.id,
    this.geomEncoded,
    this.geomType,
  });

  Geoboundaries.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    type = json['Type'];
    id = json['Id'];
    geomEncoded = json['geom_encoded'];
    geomType = json['geom_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['Id'] = this.id;
    data['geom_encoded'] = this.geomEncoded;
    data['geom_type'] = this.geomType;
    return data;
  }
}
