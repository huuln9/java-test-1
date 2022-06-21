class PlaceLocationModel {
  String type;
  List<double?> coordinates;

  PlaceLocationModel({
    required this.type,
    required this.coordinates,
  });


  @override
  String toString() {
    return 'PlaceLocationModel{type: $type, coordinates: $coordinates}';
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  factory PlaceLocationModel.fromMap(Map<String, dynamic> map) {
    return PlaceLocationModel(
      type: map['type'] as String,
      coordinates: _convertListDynToListDouble(map['coordinates']),
    );
  }

  static List<PlaceLocationModel> fromListMap(List<dynamic> maps) {
    List<PlaceLocationModel> lst = [];
    for (var element in maps) {
      lst.add(PlaceLocationModel.fromMap(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListMap(List<PlaceLocationModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toMap());
    }
    return lst;
  }

  static List<double> _convertListDynToListDouble(List<dynamic> list) {
    return List<double>.from(list);
  }
}