import 'dart:convert';

import 'package:vncitizens_place/src/model/location.dart';
import 'package:vncitizens_place/src/model/nation.dart';
import 'package:vncitizens_place/src/model/parent.dart';
import 'package:vncitizens_place/src/model/place_detail.dart';
import 'package:vncitizens_place/src/model/tag.dart';

class PlaceContent {
  PlaceContent({
    required this.id,
    required this.thumbnail,
    required this.coverId,
    required this.name,
    required this.address,
    required this.fullPlace,
    required this.parent,
    required this.url,
    required this.location,
    required this.tags,
    required this.status,
    required this.nation,
    required this.data,
  });

  late final String id;
  late final String thumbnail;
  late final String coverId;
  late final String name;
  late final String address;
  late final String fullPlace;
  late final Parent parent;
  late final String url;
  late final Location location;
  late final List<Tag> tags;
  late final int status;
  late final Nation nation;
  late final dynamic data;

  PlaceContent.fromDetail(PlaceDetail detail) {
    id = detail.id;
    thumbnail = detail.thumbnail;
    coverId = detail.coverId;
    name = detail.name;
    address = detail.address;
    fullPlace = detail.fullPlace;
    url = detail.url;
    location = detail.location!;
    tags = detail.tags;
    status = detail.status;
    nation = detail.nation!;
    data = detail.data;
  }

  PlaceContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['thumbnail'] != null) {
      thumbnail = json['thumbnail'];
    } else {
      thumbnail = "";
    }
    coverId = json['coverId'];
    name = json['name'];
    if (json['address'] != null) {
      address = json['address'];
    } else {
      address = "";
    }
    fullPlace = json['fullPlace'];
    parent = json['parent'] == null
        ? Parent(id: '', name: '', tags: [])
        : Parent.fromJson(json['parent']);
    url = json['url'];
    location = Location.fromJson(json['location']);
    tags = List.from(json['tags']).map((e) => Tag.fromJson(e)).toList();
    status = json['status'];
    nation = Nation.fromJson(json['nation']);
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['thumbnail'] = thumbnail;
    _data['coverId'] = coverId;
    _data['name'] = name;
    _data['address'] = address;
    _data['fullPlace'] = fullPlace;
    _data['parent'] = parent.toJson();
    _data['url'] = url;
    _data['location'] = location.toJson();
    _data['tags'] = tags.map((e) => e.toJson()).toList();
    _data['status'] = status;
    _data['nation'] = nation.toJson();
    // _data['data'] = data;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
