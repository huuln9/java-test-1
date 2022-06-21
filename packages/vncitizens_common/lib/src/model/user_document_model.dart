import 'package:vncitizens_common/src/model/id_model.dart';

class UserDocumentModel {
  String number;
  String date;
  IdModel agency;
  _ScanImageModel? scanImage;

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
      'agency': agency,
      'scanImage': scanImage,
    };
  }

  factory UserDocumentModel.fromJson(Map<String, dynamic> map) {
    return UserDocumentModel(
      number: map['number'] as String,
      date: map['date'] as String,
      agency: IdModel.fromJson(map['agency']),
      scanImage: map['scanImage'] != null ? _ScanImageModel.fromJson(map['scanImage']) : null,
    );
  }
}

class _ScanImageModel {
  IdModel frontside;
  IdModel backside;

  _ScanImageModel({
    required this.frontside,
    required this.backside,
  });

  Map<String, dynamic> toJson() {
    return {
      'frontside': frontside,
      'backside': backside,
    };
  }

  factory _ScanImageModel.fromJson(Map<String, dynamic> map) {
    return _ScanImageModel(
      frontside: IdModel.fromJson(map['frontside']),
      backside: IdModel.fromJson(map['backside']),
    );
  }
}