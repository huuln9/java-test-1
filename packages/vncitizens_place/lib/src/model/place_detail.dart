import 'dart:convert';

import 'package:vncitizens_place/src/model/location.dart';
import 'package:vncitizens_place/src/model/nation.dart';
import 'package:vncitizens_place/src/model/tag.dart';

class PlaceDetail {
  PlaceDetail({
    this.id = '',
    this.thumbnail = '',
    this.coverId = '',
    this.media = const [],
    this.name = '',
    this.address = '',
    this.fullPlace = '',
    this.url = '',
    this.location,
    this.tags = const [],
    this.nation,
    this.primaryColor = '',
    this.status = 0,
    this.data,
  });

  late final String id;
  late final String thumbnail;
  late final String coverId;
  late final List<String> media;
  late final String name;
  late final String address;
  late final String fullPlace;
  late final String url;
  late final Location? location;
  late final List<Tag> tags;
  late final Nation? nation;
  late final String primaryColor;
  late final int status;
  late final dynamic data;

  PlaceDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['thumbnail'] != null) {
      thumbnail = json['thumbnail'];
    } else {
      thumbnail = '';
    }
    coverId = json['coverId'];
    media = List.castFrom<dynamic, String>(json['media']);
    name = json['name'];
    if (json['address'] != null) {
      address = json['address'];
    } else {
      address = "";
    }
    fullPlace = json['fullPlace'];
    url = json['url'];
    if (json['location'] != null) {
      location = Location.fromJson(json['location']);
    }
    tags = List.from(json['tags']).map((e) => Tag.fromJson(e)).toList();
    if (json['nation'] != null) {
      nation = Nation.fromJson(json['nation']);
    } else {
      nation = null;
    }
    primaryColor = json['primaryColor'];
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['thumbnail'] = thumbnail;
    _data['coverId'] = coverId;
    _data['media'] = media;
    _data['name'] = name;
    _data['address'] = address;
    _data['fullPlace'] = fullPlace;
    _data['url'] = url;
    _data['location'] = location?.toJson();
    _data['tags'] = tags.map((e) => e.toJson()).toList();
    _data['nation'] = nation?.toJson();
    _data['primaryColor'] = primaryColor;
    _data['status'] = status;
    _data['data'] = data?.toJson();
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
