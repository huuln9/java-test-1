import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class LocationCallConfig {
  final String? urlEndPoint;
  final List<SosItemModel>? dataSos;
  final String? secertKey;

  LocationCallConfig({this.urlEndPoint, this.dataSos, this.secertKey});

  factory LocationCallConfig.fromMap(Map<String, dynamic> json) {
    return LocationCallConfig(
        urlEndPoint: json['urlEndPoint'] as String,
        secertKey: json['secert_key'] as String,
        dataSos: (json['data'] as List<dynamic>?)
            ?.map((e) => SosItemModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
