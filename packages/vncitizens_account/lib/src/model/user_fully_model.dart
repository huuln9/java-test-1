
import 'package:vncitizens_account/src/model/account_model.dart';
import 'package:vncitizens_account/src/model/id_model.dart';
import 'package:vncitizens_account/src/model/id_name_model.dart';
import 'package:vncitizens_account/src/model/phone_number_model.dart';
import 'package:vncitizens_account/src/model/user_address_model.dart';
import 'package:vncitizens_account/src/model/user_bioid_model.dart';
import 'package:vncitizens_account/src/model/user_document_model.dart';
import 'package:vncitizens_account/src/model/username_type_model.dart';

class UserFullyModel {
  String? id;
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
  IdNameModel? ethnic;
  List<IdModel>? religion;
  int? order;
  UserBioIdModel? vnptBioId;
  String? avatarId;

  UserFullyModel({
    this.id,
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
    this.ethnic,
    this.religion,
    this.order,
    this.vnptBioId,
    this.avatarId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email != null && email!.isNotEmpty ? PhoneNumberModel.toListJson(email!) : [],
      'phoneNumber': PhoneNumberModel.toListJson(phoneNumber),
      'account': account.toJson(),
      'identity': identity?.toJson(),
      'citizenIdentity': citizenIdentity?.toJson(),
      'passport': passport?.toJson(),
      'birthday': birthday,
      'gender': gender,
      'address': address != null && address!.isNotEmpty ? UserAddressModel.toListJson(address!) : null,
      'ethnic': ethnic,
      'religion': religion,
      'order': order,
      'vnptBioId': vnptBioId?.toJson(),
      'avatarId': avatarId
    };
  }

  factory UserFullyModel.fromJson(Map<String, dynamic> map) {
    return UserFullyModel(
      id: map['id'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] != null ? PhoneNumberModel.fromListJson(map["email"]) : [],
      phoneNumber: PhoneNumberModel.fromListJson(map["phoneNumber"]),
      account: AccountModel.fromJson(map['account']),
      identity: map['identity'] != null && map['identity']['number'] != null ? UserDocumentModel.fromJson(map['identity']) : null,
      citizenIdentity: map['citizenIdentity'] != null && map['citizenIdentity']['number'] != null  ? UserDocumentModel.fromJson(map['citizenIdentity']) : null,
      passport: map['passport'] != null && map['passport']['number'] != null ? UserDocumentModel.fromJson(map['passport']) : null,
      birthday: map['birthday'] as String,
      gender: map['gender'] as int,
      address: map['address'] != null ? UserAddressModel.fromListJson(map["address"]) : null,
      ethnic: map['ethnic'] != null ? IdNameModel.fromMap(map["ethnic"]) : null,
      religion: map['religion'] != null ? IdModel.fromListJson(map["religion"]) : null,
      order: map['order'] as int,
      vnptBioId: map['vnptBioId'] != null ? UserBioIdModel.fromJson(map['vnptBioId']) : null,
      avatarId: map["avatarId"],
    );
  }

  factory UserFullyModel.fromJsonWithUsername(Map<String, dynamic> map, String username) {
    return UserFullyModel(
      id: map['id'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] != null ? PhoneNumberModel.fromListJson(map["email"]) : null,
      phoneNumber: PhoneNumberModel.fromListJson(map["phoneNumber"]),
      account: AccountModel(username: [UserNameTypeModel(value: username)]),
      identity: map['identity'] != null && map['identity']['number'] != null ? UserDocumentModel.fromJson(map['identity']) : null,
      citizenIdentity: map['citizenIdentity'] != null && map['citizenIdentity']['number'] != null  ? UserDocumentModel.fromJson(map['citizenIdentity']) : null,
      passport: map['passport'] != null && map['passport']['number'] != null ? UserDocumentModel.fromJson(map['passport']) : null,
      birthday: map['birthday'] as String,
      gender: map['gender'] as int,
      address: map['address'] != null ? UserAddressModel.fromListJson(map["address"]) : null,
      ethnic: map['ethnic'] != null ? IdNameModel.fromMap(map["ethnic"]) : null,
      religion: map['religion'] != null ? IdModel.fromListJson(map["religion"]) : null,
      order: map['order'] as int,
      vnptBioId: map['vnptBioId'] != null ? UserBioIdModel.fromJson(map['vnptBioId']) : null,
      avatarId: map["avatarId"],
    );
  }
}