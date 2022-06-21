class UserNameTypeModel {
  String value;
  int? type = 3;

  UserNameTypeModel({
    required this.value,
    this.type = 3,
  });


  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'type': type,
    };
  }

  factory UserNameTypeModel.fromJson(Map<String, dynamic> map) {
    return UserNameTypeModel(
      value: map['username'] as String,
      type: map['type'] as int,
    );
  }

  static List<UserNameTypeModel> fromListJson(List<dynamic> maps) {
    List<UserNameTypeModel> lst = [];
    for (var element in maps) {
      lst.add(UserNameTypeModel.fromJson(element));
    }
    return lst;
  }

  static List<Map<String, dynamic>> toListJson(List<UserNameTypeModel> elements) {
    List<Map<String, dynamic>> lst = [];
    for (var element in elements) {
      lst.add(element.toJson());
    }
    return lst;
  }
}