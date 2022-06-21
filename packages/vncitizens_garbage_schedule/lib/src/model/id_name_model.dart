class IdNameModel {
  String id;
  String? name;

  IdNameModel({required this.id, this.name});

  factory IdNameModel.fromMap(Map<String, dynamic> map) {
    return IdNameModel(
      id: map['id'] as String,
      name: map['name'] ?? '',
    );
  }
}
