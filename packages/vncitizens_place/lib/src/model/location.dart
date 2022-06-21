import 'dart:convert';

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  late final String type;
  late final List<double> coordinates;

  Location.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      type = json['type'];
      coordinates = List.castFrom<dynamic, double>(json['coordinates']);
    } else {
      coordinates = [];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['coordinates'] = coordinates;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());

  bool isEmpty() {
    return coordinates.isEmpty;
  }
}
