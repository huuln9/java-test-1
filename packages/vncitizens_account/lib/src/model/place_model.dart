import 'package:vncitizens_account/src/model/id_name_model.dart';

class PlaceModel {
  String id;
  String name;
  String? address;
  String? fullPlace;
  IdNameModel? parent;
  IdNameModel? nation;
  List<IdNameModel>? ancestors;

  PlaceModel({
    required this.id,
    required this.name,
    this.address,
    this.fullPlace,
    this.parent,
    this.nation,
    this.ancestors,
  });

  @override
  String toString() {
    return 'PlaceModel{id: $id, name: $name, address: $address, fullPlace: $fullPlace, parent: $parent, nation: $nation, ancestors: $ancestors}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'fullPlace': fullPlace,
      'parent': parent,
      'nation': nation,
      'ancestors': ancestors,
    };
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      fullPlace: map['fullPlace'] as String,
      parent: map['parent'] != null ? IdNameModel.fromMap(map['parent']) : null,
      nation: map['nation'] != null ? IdNameModel.fromMap(map['nation']) : null,
      ancestors: map['ancestors'] != null ? IdNameModel.fromListMap(map['ancestors']) : []
    );
  }

  static List<PlaceModel> fromListMap(List<dynamic> maps) {
    List<PlaceModel> lst = [];
    for (var element in maps) {
      lst.add(PlaceModel.fromMap(element));
    }
    return lst;
  }
}