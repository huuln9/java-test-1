import 'package:vncitizens_garbage_schedule/src/model/id_name_model.dart';

class PlaceModel {
  IdNameModel? ward;
  IdNameModel? district;
  IdNameModel? province;
  IdNameModel? nation;

  PlaceModel({
    required this.ward,
    required this.district,
    required this.province,
    required this.nation,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      ward: map['ward'] != null ? IdNameModel.fromMap(map['ward']) : null,
      district: map['district'] != null ? IdNameModel.fromMap(map['district']) : null,
      province: map['province'] != null ? IdNameModel.fromMap(map['province']) : null,
      nation: map['nation'] != null ? IdNameModel.fromMap(map['nation']) : null,
    );
  }
}
