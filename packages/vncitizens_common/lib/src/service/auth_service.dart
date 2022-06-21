import 'dart:convert';
import 'dart:developer';

import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/src/model/account_model.dart';
import 'package:vncitizens_common/src/model/phone_number_model.dart';
import 'package:vncitizens_common/src/model/user_address_model.dart';
import 'package:vncitizens_common/src/model/user_bioid_model.dart';
import 'package:vncitizens_common/src/model/user_document_model.dart';
import 'package:vncitizens_common/src/model/user_post_fully_model.dart';
import 'package:vncitizens_common/src/model/user_put_fully_model.dart';
import 'package:vncitizens_common/src/model/username_type_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AuthService extends GetConnect {
  static const String _prefix = "auth";
  static const Duration _timeout = Duration(seconds: 30);

  Future<Response> createUserFully({
    required String fullname,
    required String phoneNumber,
    String? email,
    required String password,
    Map<String, dynamic>? identity,
    Map<String, dynamic>? citizenIdentity,
    Map<String, dynamic>? passport,
    List<Map<String, dynamic>>? address,
    String? birthday,
    int? gender,
    String? personId,
  }) async {
    List<PhoneNumberModel> phones = [];
    phones.add(PhoneNumberModel(value: phoneNumber));
    List<PhoneNumberModel> emails = [];
    List<UserNameTypeModel> usernames = [];
    usernames.add(UserNameTypeModel(value: phoneNumber));
    if (email != null && email.isNotEmpty) {
      usernames.add(UserNameTypeModel(value: email));
      emails.add(PhoneNumberModel(value: email));
    }
    AccountModel account = AccountModel(username: usernames, password: password);
    /// identity
    UserDocumentModel? identityModel;
    if (identity != null) {
      identityModel = UserDocumentModel.fromJson(identity);
    }
    /// citizen identity
    UserDocumentModel? citizenIdentityModel;
    if (citizenIdentity != null) {
      citizenIdentityModel = UserDocumentModel.fromJson(citizenIdentity);
    }
    /// passport
    UserDocumentModel? passportModel;
    if (passport != null) {
      passportModel = UserDocumentModel.fromJson(passport);
    }
    /// address
    List<UserAddressModel>? userAddressModel = [];
    if (address != null && address.isNotEmpty) {
      for (var element in address) {
        userAddressModel.add(UserAddressModel.fromJson(element));
      }
    }
    /// vnpt bioid
    UserBioIdModel? userBioIdModel;
    if (personId != null) {
      userBioIdModel = UserBioIdModel(personId: personId);
    }
    UserPostFullyModel model = UserPostFullyModel(
        fullname: fullname,
        phoneNumber: phones,
        account: account,
        email: emails,
        identity: identityModel,
        citizenIdentity: citizenIdentityModel,
        passport: passportModel,
        address: userAddressModel,
        birthday: birthday,
        gender: gender,
        vnptBioId: userBioIdModel
    );
    final body = jsonEncode(model);
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    log(body, name: AppConfig.packageName + " BODY");
    return await post("${AppConfig.iscsApiEndpoint}/$_prefix/user/--fully", body,
        contentType: "application/json", headers: headers);
  }

  Future<Response> getUserFully(String id) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    return await get("${AppConfig.iscsApiEndpoint}/$_prefix/user/$id/--fully", headers: headers);
  }

  Future<Response> getUserFullyByUsername(String username) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/--by-account-username?username=$username";
    log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url, headers: headers);
  }

  Future<Response> updateUserFully(
      {required String id,
      required String fullname,
      required List<String> phoneNumbers,
      List<String>? emails,
      required List<String> usernames,
      String? password,
      int? verificationLevel}) async {
    /// phone numbers
    List<PhoneNumberModel> tmpPhones = [];
    for (var element in phoneNumbers) {
      tmpPhones.add(PhoneNumberModel(value: element));
    }

    /// mails
    List<PhoneNumberModel> tmpMails = [];
    if (emails != null && emails.isNotEmpty) {
      for (var email in emails) {
        tmpMails.add(PhoneNumberModel(value: email));
      }
    }

    /// usernames
    List<UserNameTypeModel> tmpUsernames = [];
    if (usernames.isNotEmpty) {
      for (var username in usernames) {
        tmpUsernames.add(UserNameTypeModel(value: username));
      }
    }
    AccountModel account = AccountModel(username: tmpUsernames, password: password, verificationLevel: verificationLevel);
    UserPutFullyModel model =
        UserPutFullyModel(fullname: fullname, phoneNumber: tmpPhones, email: tmpMails, account: account);
    final body = jsonEncode(model);
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    log(body.toString(), name: runtimeType.toString() + ".updateUserFully BODY");
    return await put("${AppConfig.iscsApiEndpoint}/$_prefix/user/$id/--fully", body,
        contentType: "application/json", headers: headers);
  }

  Future<Response> confirmPassword({required String username, required String password}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/account/--confirm-password?username=$username&password=$password";
    return await get(url, headers: headers);
  }

  Future<Response> resetPassword({required String username, required String password}) async {
    Map<String, String> body = {
      "username": username,
      "password": password
    };
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/account/--reset-password";
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    log(url, name: runtimeType.toString() + ".resetPassword");
    log(body.toString(), name: runtimeType.toString() + ".resetPassword");
    return await put(url, body, contentType: "application/x-www-form-urlencoded", headers: headers);
  }

  Future<Response> updateBioId({
    required String id,
    required int enableFaceLogin,
    required String personId,
  }) async {
    Map<String, dynamic> body = {
      "enableFaceLogin": enableFaceLogin,
      "personId": personId
    };
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/$id/vnpt-bioid";
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    log(url, name: runtimeType.toString() + ".updateBioId");
    log(body.toString(), name: runtimeType.toString() + ".updateBioId");
    return await put(url, body, contentType: "application/json", headers: headers);
  }

  Future<Response> checkAccountExists({required String username}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/account/--exists?username=$username";
    return await get(url, headers: headers);
  }

  Future<Response> checkPhoneNumberExists({required String phoneNumber}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/phone-number/--exists/?phone-number=$phoneNumber";
    return await get(url, headers: headers);
  }

  Future<Response> checkEmailExists({required String email}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/email/--exists/?email=$email";
    log(url, name: runtimeType.toString() + ".checkEmailExists");
    return await get(url, headers: headers);
  }

  Future<Response> changePassword({required String username, required String currentPassword, required String newPassword}) async {
    Map<String, String> body = {
      "username": username,
      "currentPassword": currentPassword,
      "newPassword": newPassword
    };
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/account/--update-password";
    return await put(url, body, headers: headers, contentType: "application/x-www-form-urlencoded");
  }

  Future<Response> updateUserFullyByJson({required String id, required Map<String, dynamic> json}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/$id/--fully";
    log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await put(url, json, contentType: "application/json", headers: headers);
  }

  Future<Response> updateAvatar({required String userId, required String avatarId}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    Map<String, String> body = {
      "avatarId": avatarId
    };
    FormData formData = FormData({
      "avatarId": avatarId
    });
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/$userId/avatar";
    log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await put(url, formData, headers: headers);
  }

  Future<Response> updateAddress({required String id, required List<dynamic> address}) async{
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = "${AppConfig.iscsApiEndpoint}/$_prefix/user/$id/address";
    log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await put(url, address, contentType: "application/json", headers: headers).timeout(_timeout);
  }
}
