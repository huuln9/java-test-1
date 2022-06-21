class UserBioIdModel {
  String personId;

  UserBioIdModel({
    required this.personId,
  });

  @override
  String toString() {
    return 'UserBioIdModel{personId: $personId}';
  }

  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
    };
  }

  factory UserBioIdModel.fromJson(Map<String, dynamic> map) {
    return UserBioIdModel(
      personId: map['personId'] as String,
    );
  }
}