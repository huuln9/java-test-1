class HCMPlaceResource {
  String resourceId = '';
  final String? name;
  final String? license;
  String? address;
  final String? approvedDate;
  final String? status;
  final String? subName;
  final String? lienCap;
  final String? tenMien;
  final String? phone;
  final String? soCCHNNDD;

  bool isSelected = false;
  double latitude = 0.0;
  double longtitude = 0.0;

  HCMPlaceResource(
      {this.name,
      this.license,
      this.address,
      this.approvedDate,
      this.status,
      this.subName,
      this.lienCap,
      this.tenMien,
      this.phone,
      this.soCCHNNDD});

  factory HCMPlaceResource.fromJson(Map<String, dynamic> json) {
    if (json['TenDonVi'] != null) {
      return HCMPlaceResource(
          name: json['TenDonVi'],
          address: json['DiaChi'],
          lienCap: json['LienCap'],
          tenMien: json['TenMien']);
    } else if (json['TenCoSo'] != null) {
      return HCMPlaceResource(
          name: json['TenCoSo'],
          address: json['DiaChi'],
          status: json['TinhTrang'],
          subName: json['TenHinhThuc'],
          approvedDate: json['NgayCap'],
          license: json['SoGiayPhep'],
          soCCHNNDD: json['SoCCHN_NDD']);
    } else {
      var address = "";
      if (json['Number'] != null && json['Number'].toString().isNotEmpty) {
        address += json['Number'] + ', ';
      }
      if (json['Street'] != null && json['Street'].toString().isNotEmpty) {
        address += json['Street'] + ', ';
      }
      if (json['Ward'] != null && json['Ward'].toString().isNotEmpty) {
        address += json['Ward'] + ', ';
      }
      if (json['Province'] != null && json['Province'].toString().isNotEmpty) {
        address += json['Province'];
      }
      var data = HCMPlaceResource(
          name: json['Name'], address: address, phone: json['Phone']);
      data.latitude = json['Latitude'];
      data.longtitude = json['Longitude'];
      return data;
    }
  }
}

class HCMPlaceResourceResponse {
  final int? limit;
  final int? total;
  final List<HCMPlaceResource>? records;

  HCMPlaceResourceResponse({this.limit, this.total, this.records});
  factory HCMPlaceResourceResponse.fromJson(Map<String, dynamic> json) {
    return HCMPlaceResourceResponse(
        limit: json['limit'],
        total: json['total'],
        records: (json['records'] as List<dynamic>?)
            ?.map((e) => HCMPlaceResource.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
