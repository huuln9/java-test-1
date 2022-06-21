class UserAddressModel {
  String address;
  String placeId;
  int? type;

  UserAddressModel({
    required this.address,
    required this.placeId,
    this.type = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'placeId': placeId,
      'type': type,
    };
  }

  factory UserAddressModel.fromJson(Map<String, dynamic> map) {
    return UserAddressModel(
      address: map['address'] as String,
      placeId: map['placeId'] as String,
      type: map['type'] as int,
    );
  }

  static List<UserAddressModel> fromListJson(List<dynamic> maps) {
    List<UserAddressModel> lst = [];
    for (var element in maps) {
      lst.add(UserAddressModel.fromJson(element));
    }
    return lst;
  }
}