import 'package:latlong2/latlong.dart';

class AddressInfo {
  LatLng? point;
  String? address;
  String? provinceId;
  String? distId;
  String? wardId;
  String? provinceName;
  String? distName;
  String? wardName;

  AddressInfo({
    this.point,
    this.address,
    this.provinceId,
    this.distId,
    this.wardId,
    this.provinceName,
    this.distName,
    this.wardName,
  });

  AddressInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    provinceId = json['province_id'];
    distId = json['dist_id'];
    wardId = json['ward_id'];
    provinceName = json['province_name'];
    distName = json['dist_name'];
    wardName = json['ward_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['province_id'] = this.provinceId;
    data['dist_id'] = this.distId;
    data['ward_id'] = this.wardId;
    data['province_name'] = this.provinceName;
    data['dist_name'] = this.distName;
    data['ward_name'] = this.wardName;
    return data;
  }
}
