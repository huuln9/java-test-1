class IdNameModel {
  String id;
  String? name;

  IdNameModel({
    required this.id,
    this.name,
  });

  @override
  String toString() {
    return 'IdNameModel{' ' id: $id,' ' name: $name,' '}';
  }

  IdNameModel copyWith({
    String? id,
    String? name,
  }) {
    return IdNameModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

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

  static List<Map<String, dynamic>> toListMap(List<IdNameModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }

  static List<IdNameModel> fromListMap(List<dynamic> maps) {
    List<IdNameModel> lst = [];
    for (var element in maps) {
      lst.add(IdNameModel.fromMap(element));
    }
    return lst;
  }
}
