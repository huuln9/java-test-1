import 'package:vncitizens_common/src/model/account_model.dart';
import 'package:vncitizens_common/src/model/phone_number_model.dart';
import 'package:vncitizens_common/src/model/user_address_model.dart';
import 'package:vncitizens_common/src/model/user_bioid_model.dart';
import 'package:vncitizens_common/src/model/user_document_model.dart';

class UserPostFullyModel {
  String fullname;
  List<PhoneNumberModel>? email;
  List<PhoneNumberModel> phoneNumber;
  AccountModel account;
  UserDocumentModel? identity;
  UserDocumentModel? citizenIdentity;
  UserDocumentModel? passport;
  String? birthday;
  int? gender;
  List<UserAddressModel>? address;
  UserBioIdModel? vnptBioId;

  UserPostFullyModel({
    required this.fullname,
    this.email,
    required this.phoneNumber,
    required this.account,
    this.identity,
    this.citizenIdentity,
    this.passport,
    this.birthday,
    this.gender,
    this.address,
    this.vnptBioId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'account': account,
      'identity': identity,
      'citizenIdentity': citizenIdentity,
      'passport': passport,
      'birthday': birthday,
      'gender': gender,
      'address': address,
      'vnptBioId': vnptBioId?.toJson(),
    };
  }

  factory UserPostFullyModel.fromJson(Map<String, dynamic> map) {
    return UserPostFullyModel(
      fullname: map['fullname'] as String,
      email: map['email'] as List<PhoneNumberModel>,
      phoneNumber: map['phoneNumber'] as List<PhoneNumberModel>,
      account: map['account'] as AccountModel,
      identity: map['identity'] as UserDocumentModel,
      citizenIdentity: map['citizenIdentity'] as UserDocumentModel,
      passport: map['passport'] as UserDocumentModel,
      birthday: map['birthday'] as String,
      gender: map['gender'] as int,
      address: map['address'] as List<UserAddressModel>,
      vnptBioId: map['vnptBioId'] != null ? UserBioIdModel.fromJson(map['vnptBioId']) : null,
    );
  }
}