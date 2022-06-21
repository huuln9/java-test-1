import 'package:vncitizens_account/src/model/id_model.dart';
import 'package:vncitizens_account/src/model/id_name_model.dart';

class UserDocumentModel {
  String number;
  String date;
  IdNameModel agency;
  ScanImageModel? scanImage;

  UserDocumentModel({
    required this.number,
    required this.date,
    required this.agency,
    this.scanImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'date': date,
      'agency': agency.toMap(),
      'scanImage': scanImage?.toJson(),
    };
  }

  factory UserDocumentModel.fromJson(Map<String, dynamic> map) {
    return UserDocumentModel(
      number: map['number'] as String,
      date: map['date'] as String,
      agency: IdNameModel.fromMap(map['agency']),
      scanImage: map['scanImage'] != null ? ScanImageModel.fromJson(map['scanImage']) : null,
    );
  }
}

class ScanImageModel {
  IdModel frontside;
  IdModel backside;

  ScanImageModel({
    required this.frontside,
    required this.backside,
  });

  Map<String, dynamic> toJson() {
    return {
      'frontside': frontside.toJson(),
      'backside': backside.toJson(),
    };
  }

  factory ScanImageModel.fromJson(Map<String, dynamic> map) {
    return ScanImageModel(
      frontside: IdModel.fromJson(map['frontside']),
      backside: IdModel.fromJson(map['backside']),
    );
  }
}
