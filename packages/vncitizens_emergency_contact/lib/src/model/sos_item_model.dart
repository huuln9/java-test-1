class SosItemModel {
  String? name;
  String? phoneNumber;
  String? image;
  String? dialNumber;
  double? lat = 0.0;
  double? long = 0.0;

  SosItemModel({this.name, this.phoneNumber, this.image, this.dialNumber});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'image': image,
    };
  }

  factory SosItemModel.fromJson(Map<String, dynamic> map) {
    return SosItemModel(
      phoneNumber: map['phone'] as String,
      dialNumber: map['number'] as String,
    );
  }
}
