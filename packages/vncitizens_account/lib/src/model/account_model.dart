import 'package:vncitizens_account/src/model/username_type_model.dart';

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
      'username': UserNameTypeModel.toListJson(username),
      'password': password,
      'verificationLevel': verificationLevel,
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> map) {
    return AccountModel(
      username: UserNameTypeModel.fromListJson(map['username']),
      password: map['password'] as String,
      verificationLevel: map['verificationLevel'] as int,
    );
  }
}
