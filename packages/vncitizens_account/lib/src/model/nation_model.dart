class NationModel {
  String id;
  String name;
  String deploymentId;
  String owner;

  NationModel({
    required this.id,
    required this.name,
    required this.deploymentId,
    required this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'deploymentId': deploymentId,
      'owner': owner,
    };
  }

  factory NationModel.fromMap(Map<String, dynamic> map) {
    return NationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      deploymentId: map['deploymentId'] as String,
      owner: map['owner'] as String,
    );
  }

  static List<NationModel> fromListMap(List<dynamic> maps) {
    List<NationModel> lst = [];
    for (var element in maps) {
      lst.add(NationModel.fromMap(element));
    }
    return lst;
  }
}