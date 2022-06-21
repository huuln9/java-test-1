class DossierModel {
  String id;
  String code;
  IdNameModel dossierStatus;
  IdNameModel applicant;
  String agency;
  String returnMethod;
  String agencyAddress;
  String? statusString;
  IdNameModel procedure;
  String createdDate;
  String acceptedDate;
  String appointmentDate;
  String completedDate;
  String returnedDate;

  DossierModel({
    required this.id,
    required this.code,
    required this.dossierStatus,
    required this.applicant,
    required this.agency,
    required this.returnMethod,
    required this.agencyAddress,
    this.statusString,
    required this.procedure,
    required this.createdDate,
    required this.acceptedDate,
    required this.appointmentDate,
    required this.completedDate,
    required this.returnedDate,
  });

  factory DossierModel.fromJson(Map<String, dynamic> json) {
    return DossierModel(
      id: json['id'] as String,
      code: json['code'] as String,
      dossierStatus: IdNameModel.fromJson(json['dossierStatus']),
      applicant: IdNameModel.fromJson(json['applicant']),
      agency: json['agency'] as String,
      returnMethod: json['returnMethod'] as String,
      agencyAddress: json['agencyAddress'] as String,
      statusString: json['statusString'] ?? '',
      procedure: IdNameModel.fromJson(json['procedure']),
      createdDate: json['createdDate'] as String,
      acceptedDate: json['acceptedDate'] as String,
      appointmentDate: json['appointmentDate'] as String,
      completedDate: json['completedDate'] as String,
      returnedDate: json['returnedDate'] as String,
    );
  }

  static List<DossierModel> fromArray(List<dynamic> jsonArr) {
    List<DossierModel> listNews = [];
    for (var json in jsonArr) {
      listNews.add(DossierModel(
        id: json['id'] as String,
        code: json['code'] as String,
        dossierStatus: IdNameModel.fromJson(json['dossierStatus']),
        applicant: IdNameModel.fromJson(json['applicant']),
        agency: json['agency'] as String,
        returnMethod: json['returnMethod'] ?? '',
        agencyAddress: json['agencyAddress'] ?? '',
        statusString: json['statusString'] ?? '',
        procedure: IdNameModel.fromJson(json['procedure']),
        createdDate: json['createdDate'] as String,
        acceptedDate: json['acceptedDate'] as String,
        appointmentDate: json['appointmentDate'] as String,
        completedDate: json['completedDate'] as String,
        returnedDate: json['returnedDate'] as String,
      ));
    }
    return listNews;
  }
}

class IdNameModel {
  String id;
  String name;
  String? identityNumber;

  IdNameModel({required this.id, required this.name, this.identityNumber});

  factory IdNameModel.fromJson(Map<String, dynamic> json) {
    return IdNameModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      identityNumber: json['identityNumber'] ?? '',
    );
  }
}
