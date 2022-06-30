class NearBySearch {
  String? gid;
  String? label;
  String? lat;
  String? long;
  String? type;
  String? address;

  NearBySearch({
    this.gid,
    this.label,
    this.lat,
    this.long,
    this.type,
    this.address,
  });

  NearBySearch.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    label = json['label'];
    lat = json['lat'];
    long = json['long'];
    type = json['type'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['label'] = this.label;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['type'] = this.type;
    data['address'] = this.address;
    return data;
  }
}
