
class AttributeNatureStationModel {
  int su_id;
  String datatype_name;
  num data_val;

  AttributeNatureStationModel({
    required this.su_id,
    required this.datatype_name,
    required this.data_val
  });

  factory AttributeNatureStationModel.fromMap(Map<String, dynamic> map) {
    return AttributeNatureStationModel(
        su_id: map['su_id'] as int,
        datatype_name: map['datatype_name'] as String,
        data_val: map['data_val'] as num,
    );
  }
}