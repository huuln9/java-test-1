import 'dart:convert';

class TagContent {
  TagContent({
    required this.id,
    required this.code,
    required this.order,
    required this.status,
    required this.createdDate,
    required this.name,
    required this.description,
    required this.iconId,
    required this.deploymentId,
    required this.superAdminOnly,
  });

  late final String id;
  late final String code;
  late final int order;
  late final int status;
  late final String createdDate;
  late final String name;
  late final String description;
  late final String iconId;
  late final String deploymentId;
  late final int superAdminOnly;

  TagContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    order = json['order'];
    status = json['status'];
    createdDate = json['createdDate'];
    name = json['name'];
    description = json['description'];
    iconId = json['iconId'];
    deploymentId = json['deploymentId'];
    superAdminOnly = json['superAdminOnly'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['code'] = code;
    _data['order'] = order;
    _data['status'] = status;
    _data['createdDate'] = createdDate;
    _data['name'] = name;
    _data['description'] = description;
    _data['iconId'] = iconId;
    _data['deploymentId'] = deploymentId;
    _data['superAdminOnly'] = superAdminOnly;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
