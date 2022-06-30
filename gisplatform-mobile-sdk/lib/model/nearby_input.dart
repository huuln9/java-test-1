class NearbyInput {
  String? lat;
  String? lon;
  int? distance;
  String? type;

  NearbyInput({
    this.lat,
    this.lon,
    this.distance,
    this.type,
  });

  NearbyInput.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    distance = json['distance'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['distance'] = this.distance;
    data['type'] = this.type;
    return data;
  }
}
