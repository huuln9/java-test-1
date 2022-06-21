class IdModel {
  String id;

  IdModel({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory IdModel.fromJson(Map<String, dynamic> map) {
    return IdModel(
      id: map['id'] as String,
    );
  }

  static List<IdModel> fromListJson(List<dynamic> maps) {
    List<IdModel> lst = [];
    for (var element in maps) {
      lst.add(IdModel.fromJson(element));
    }
    return lst;
  }
}