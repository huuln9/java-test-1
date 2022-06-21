import 'dart:convert';

import 'package:vncitizens_place/src/model/tag.dart';

class Parent {
  Parent({
    required this.id,
    required this.name,
    required this.tags,
  });

  late final String id;
  late final String name;
  late final List<Tag> tags;

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tags = List.from(json['tags']).map((e) => Tag.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['tags'] = tags.map((e) => e.toJson()).toList();
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
