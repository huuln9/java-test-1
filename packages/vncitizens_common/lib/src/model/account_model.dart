import 'package:vncitizens_common/src/model/username_type_model.dart';

class AccountModel {
  List<UserNameTypeModel> username;
  String? password;
  int? verificationLevel = 1;

  AccountModel({
    required this.username,
    this.password,
    this.verificationLevel = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'verificationLevel': verificationLevel,
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> map) {
    return AccountModel(
      username: map['username'] as List<UserNameTypeModel>,
      password: map['password'] as String,
      verificationLevel: map['verificationLevel'] as int,
    );
  }

//</editor-fold>
}
