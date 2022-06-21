import 'package:vncitizens_account/src/model/id_name_model.dart';

class TagModel {
  String id;
  String? name;
  String? code;
  IdNameModel? parent;
  List<IdNameModel>? category;
  int order;
  int status;
  String? description;
  String? iconId;
  IdNameModel? nation;
  String deploymentId;
  int? superAdminOnly;

  TagModel({
    required this.id,
    this.name,
    this.code,
    this.parent,
    this.category,
    required this.order,
    required this.status,
    this.description,
    this.iconId,
    this.nation,
    required this.deploymentId,
    this.superAdminOnly,
  });

  @override
  String toString() {
    return 'TagModel{' ' id: $id,' ' name: $name,' ' code: $code,' ' parent: $parent,' +
        ' category: $category,' +
        ' order: $order,' +
        ' status: $status,' +
        ' description: $description,' +
        ' iconId: $iconId,' +
        ' nation: $nation,' +
        ' deploymentId: $deploymentId,' +
        ' superAdminOnly: $superAdminOnly,' +
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'parent': parent,
      'category': category,
      'order': order,
      'status': status,
      'description': description,
      'iconId': iconId,
      'nation': nation,
      'deploymentId': deploymentId,
      'superAdminOnly': superAdminOnly,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      parent: map['parent'] != null ? IdNameModel.fromMap(map['parent']) : null,
      category: map['category'] != null ? IdNameModel.fromListMap(map['category']) : null,
      order: map['order'] as int,
      status: map['status'] as int,
      description: map['description'] as String,
      iconId: map['iconId'] as String,
      nation: map['nation'] != null ? IdNameModel.fromMap(map['nation']) : null,
      deploymentId: map['deploymentId'] as String,
      superAdminOnly: map['superAdminOnly'] as int,
    );
  }

  static List<TagModel> fromListMap(List<dynamic> maps) {
    List<TagModel> lst = [];
    for (var element in maps) {
      lst.add(TagModel.fromMap(element));
    }
    return lst;
  }
}