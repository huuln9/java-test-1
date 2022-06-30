class Label {
  String? label;
  double? lat;
  double? lon;
  String? address;

  Label({
    this.label,
    this.lat,
    this.lon,
    this.address,
  });

  Label.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    lat = json['lat'];
    lon = json['lon'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['address'] = this.address;
    return data;
  }
}
