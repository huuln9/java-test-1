class PlaceResult {
  String? gid;
  String? address;
  String? lat;
  String? long;
  String? id;
  String? type;

  PlaceResult({
    this.gid,
    this.address,
    this.lat,
    this.long,
    this.id,
    this.type,
  });

  PlaceResult.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}
