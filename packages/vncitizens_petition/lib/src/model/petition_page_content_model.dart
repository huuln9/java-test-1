import 'package:vncitizens_common/vncitizens_common.dart';

class PetitionPageContentModel {
  PetitionPageContentModel({
    required this.num,
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.tag,
    required this.createdDate,
    required this.status,
    required this.statusDescription,
    required this.takePlaceAt,
    required this.thumbnailId,
    required this.reaction,
    required this.reporter,
  });

  late final int num;
  late final String id;
  late final String title;
  late final String code;
  late final String description;
  late final int status;
  late final String statusDescription;
  late final TakePlaceAt takePlaceAt;
  late final String thumbnailId;
  late final Reaction reaction;
  late final DateTime createdDate;
  late final Tag tag;
  late final Reporter reporter;

  PetitionPageContentModel.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    id = json['id'];
    title = json['title'];
    code = json['code'];
    description = json['description'];
    createdDate = TimeZoneHelper.convert(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['createdDate']));
    status = json['status'];
    statusDescription = json['statusDescription'];
    takePlaceAt = TakePlaceAt.fromJson(json['takePlaceAt']);
    thumbnailId = json['thumbnailId'];
    reaction = Reaction.fromJson(json['reaction']);
    tag = Tag.fromJson(json['tag']);
    reporter = Reporter.fromJson(json['reporter']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['num'] = num;
    _data['id'] = id;
    _data['title'] = title;
    _data['code'] = code;
    _data['description'] = description;
    _data['tag'] = tag.toJson();
    _data['createdDate'] = createdDate;
    _data['status'] = status;
    _data['statusDescription'] = statusDescription;
    _data['takePlaceAt'] = takePlaceAt.toJson();
    _data['thumbnailId'] = thumbnailId;
    _data['reaction'] = reaction.toJson();
    return _data;
  }
}

class Tag {
  Tag({
    required this.id,
    required this.name,
  });

  late final String id;
  late final String name;

  Tag.fromJson(Map<String, dynamic> json) {
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

class TakePlaceAt {
  TakePlaceAt({
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  late final double latitude;
  late final double longitude;
  late final String fullAddress;

  TakePlaceAt.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longtitude'];
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longtitude'] = longitude;
    _data['fullAddress'] = fullAddress;
    return _data;
  }
}

class Reaction {
  Reaction({
    required this.satisfied,
    required this.normal,
    required this.unsatisfied,
  });

  late final int satisfied;
  late final int normal;
  late final int unsatisfied;

  Reaction.fromJson(Map<String, dynamic> json) {
    satisfied = json['satisfied'];
    normal = json['normal'];
    unsatisfied = json['unsatisfied'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['satisfied'] = satisfied;
    _data['normal'] = normal;
    _data['unsatisfied'] = unsatisfied;
    return _data;
  }
}

class Reporter {
  Reporter({
    required this.id,
    required this.username,
    required this.fullname,
    required this.phone,
    required this.identityId,
    required this.type,
  });
  late final String id;
  late final String username;
  late final String fullname;
  late final String phone;
  late final String identityId;
  late final int type;

  Reporter.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    phone = json['phone'];
    identityId = json['identityId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['fullname'] = fullname;
    _data['phone'] = phone;
    _data['identityId'] = identityId;
    _data['type'] = type;
    return _data;
  }
}
