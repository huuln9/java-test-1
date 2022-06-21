import 'package:vncitizens_common/src/model/account_model.dart';
import 'package:vncitizens_common/src/model/id_model.dart';
import 'package:vncitizens_common/src/model/id_name_model.dart';
import 'package:vncitizens_common/src/model/phone_number_model.dart';
import 'package:vncitizens_common/src/model/user_address_model.dart';
import 'package:vncitizens_common/src/model/user_document_model.dart';

class UserPutFullyModel {
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

  UserPutFullyModel({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'ethnic': ethnic,
      'religion': religion,
      'order': order,
    };
  }

  factory UserPutFullyModel.fromJson(Map<String, dynamic> map) {
    return UserPutFullyModel(
      id: map['id'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] != null ? PhoneNumberModel.fromListJson(map["email"]) : null,
      phoneNumber: PhoneNumberModel.fromListJson(map["phoneNumber"]),
      account: AccountModel.fromJson(map['account']),
      identity: map['identity'] != null ? UserDocumentModel.fromJson(map['identity']) : null,
      citizenIdentity: map['citizenIdentity'] != null ? UserDocumentModel.fromJson(map['citizenIdentity']) : null,
      passport: map['passport'] != null ? UserDocumentModel.fromJson(map['passport']) : null,
      birthday: map['birthday'] as String,
      gender: map['gender'] as int,
      address: map['address'] != null ? UserAddressModel.fromListJson(map["address"]) : null,
      ethnic: map['ethnic'] != null ? IdNameModel.fromMap(map["ethnic"]) : null,
      religion: map['religion'] != null ? IdModel.fromListJson(map["religion"]) : null,
      order: map['order'] as int,
    );
  }
}