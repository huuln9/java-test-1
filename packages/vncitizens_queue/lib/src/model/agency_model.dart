class AgencyModel {
  String? name;
  String? id;

  AgencyModel({
    this.name,
    this.id,
  });

  factory AgencyModel.fromMap(Map<String, dynamic> map) {
    return AgencyModel(
        id: map['id'] as String, name: map['name'] as String);
  }
}
