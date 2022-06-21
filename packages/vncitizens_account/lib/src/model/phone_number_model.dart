class PhoneNumberModel {
  String value;

  PhoneNumberModel({required this.value});

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  factory PhoneNumberModel.fromJson(Map<String, dynamic> map) {
    return PhoneNumberModel(
      value: map['value'] as String,
    );
  }

  static List<PhoneNumberModel> fromListJson(List<dynamic> maps) {
    List<PhoneNumberModel> lst = [];
    for (var element in maps) {
      lst.add(PhoneNumberModel.fromJson(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListJson(List<PhoneNumberModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toJson());
    }
    return lst;
  }
}
