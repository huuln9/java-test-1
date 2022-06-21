class InfoModel {
  String? fullName;
  String? identity;
  String? phoneNumber;
  String? address;

  InfoModel({
    this.fullName,
    this.identity,
    this.phoneNumber,
    this.address,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
        fullName: json['fullname'] as String,
        identity: json['identity']?['number'] ?? '',
        phoneNumber: json['phoneNumber'].isEmpty
            ? ''
            : json['phoneNumber'][0]['value'] as String,
        address: json['address'] == null
            ? ''
            : json['address'][0]['address'] as String);
  }
}
