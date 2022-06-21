class UserBioIdModel {
  String personId;
  int? enableFaceLogin;

  UserBioIdModel({
    required this.personId,
    this.enableFaceLogin,
  });

  @override
  String toString() {
    return 'UserBioIdModel{personId: $personId, enableFaceLogin: $enableFaceLogin}';
  }

  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
      'enableFaceLogin': enableFaceLogin,
    };
  }

  factory UserBioIdModel.fromJson(Map<String, dynamic> map) {
    return UserBioIdModel(
      personId: map['personId'] as String,
      enableFaceLogin: map['enableFaceLogin'] != null ? map['enableFaceLogin'] as int : null,
    );
  }

  UserBioIdModel copyWith({
    String? personId,
    int? enableFaceLogin,
  }) {
    return UserBioIdModel(
      personId: personId ?? this.personId,
      enableFaceLogin: enableFaceLogin ?? this.enableFaceLogin,
    );
  }
}
