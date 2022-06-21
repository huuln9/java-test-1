class TagModel {
  TagModel({
    required this.id,
    required this.name,
  });

  late String id;
  late String name;

  TagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
