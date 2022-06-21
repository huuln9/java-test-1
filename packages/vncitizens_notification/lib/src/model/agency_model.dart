class AgencyModel {
  AgencyModel({
    required this.id,
    required this.logoId,
    required this.name,
  });

  late String id;
  late String logoId;
  late String name;

  AgencyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['logoId'] != null) {
      logoId = json['logoId'];
    } else {
      logoId = "";
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['logoId'] = logoId;
    _data['name'] = name;
    return _data;
  }
}
