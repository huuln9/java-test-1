class SystemModel {
  SystemModel({
    required this.id,
    required this.logoURL,
    required this.name,
  });

  late String id;
  late String logoURL;
  late String name;

  SystemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['logoURL'] != null) {
      logoURL = json['logoURL'];
    } else {
      logoURL = "";
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['logoURL'] = logoURL;
    _data['name'] = name;
    return _data;
  }
}
