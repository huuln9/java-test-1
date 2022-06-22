class IdNameModel {
  String id;
  String? name;

  IdNameModel({
    required this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory IdNameModel.fromMap(Map<String, dynamic> map) {
    return IdNameModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  static List<IdNameModel> fromListMap(List<dynamic> maps) {
    List<IdNameModel> lst = [];
    for (var element in maps) {
      lst.add(IdNameModel.fromMap(element));
    }
    return lst;
  }
}