class PlaceModel {
  PlaceModel({required this.id, required this.name, required this.ancestors});

  late final String id;
  late final String name;
  late final List<Ancestors> ancestors;

  PlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ancestors =
        List.from(json['ancestors']).map((e) => Ancestors.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['ancestors'] = ancestors.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Tags {
  Tags({
    required this.id,
    required this.name,
  });

  late final String id;
  late final String name;

  Tags.fromJson(Map<String, dynamic> json) {
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

class Ancestors {
  Ancestors({
    required this.id,
    required this.name,
    required this.tags,
  });

  late final String id;
  late final String name;
  late final List<Tags> tags;

  Ancestors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // tags = List.from(json['tags']).map((e) => Tags.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    // _data['tags'] = tags.map((e) => e.toJson()).toList();
    return _data;
  }
}
