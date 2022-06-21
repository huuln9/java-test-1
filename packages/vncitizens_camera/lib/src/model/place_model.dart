import 'package:vncitizens_camera/src/model/id_name_model.dart';
import 'package:vncitizens_camera/src/model/place_location_model.dart';

class PlaceModel {
  String id;
  String name;
  String? address;
  String? fullPlace;
  String? url;
  PlaceLocationModel location;
  List<IdNameModel> tags;

  PlaceModel({required this.id, required this.name, this.address, this.fullPlace, required this.location, this.url, required this.tags});

  @override
  String toString() {
    return 'PlaceModel{id: $id, name: $name, address: $address, fullPlace: $fullPlace, url: $url, location: $location, tags: $tags}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'fullPlace': fullPlace,
      'location': location.toMap(),
      'url': url,
      'tags': IdNameModel.toListMap(tags)
    };
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
        id: map['id'] as String,
        name: map['name'] as String,
        address: map['address'] as String,
        fullPlace: map['fullPlace'] as String,
        url: map['url'] as String,
        location: PlaceLocationModel.fromMap(map['location']),
        tags: IdNameModel.fromListMap(map["tags"]));
  }

  static List<PlaceModel> fromListMap(List<dynamic> maps) {
    List<PlaceModel> lst = [];
    for (var element in maps) {
      lst.add(PlaceModel.fromMap(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListMap(List<PlaceModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }
}
