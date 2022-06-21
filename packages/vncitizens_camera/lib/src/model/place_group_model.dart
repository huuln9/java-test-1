import 'package:vncitizens_camera/src/model/place_model.dart';

class PlaceGroupModel {
  String id;
  String name;
  List<PlaceModel> places;

  PlaceGroupModel({
    required this.id,
    required this.name,
    required this.places,
  });

  @override
  String toString() {
    return 'PlaceGroupModel{id: $id, name: $name, places: $places}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'places': PlaceModel.toListMap(places),
    };
  }

  factory PlaceGroupModel.fromMap(Map<String, dynamic> map) {
    return PlaceGroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      places: PlaceModel.fromListMap(map['places']),
    );
  }

  factory PlaceGroupModel.fromMapWithoutPlace(Map<String, dynamic> map) {
    return PlaceGroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      places: [],
    );
  }

  static List<PlaceGroupModel> fromListMap(List<dynamic> maps) {
    List<PlaceGroupModel> lst = [];
    for (var element in maps) {
      lst.add(PlaceGroupModel.fromMap(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListMap(List<PlaceGroupModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }
}