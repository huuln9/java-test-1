class DocumentModel {
  /// loai giay to
  String cardType;

  /// so can cuoc / chung minh / ho chieu
  String id;

  /// ho ten
  String name;

  /// gioi tinh
  String? gender;

  /// ngay sinh
  String birthDay;

  /// d/c thuong tru
  String recentLocation;

  /// que quan
  String originLocation;

  /// ngay cap
  String issueDate;

  /// noi cap
  String issuePlace;

  /// quoc tich
  String nationality;

  DocumentModel({
    required this.cardType,
    required this.id,
    required this.name,
    this.gender,
    required this.birthDay,
    required this.recentLocation,
    required this.originLocation,
    required this.issueDate,
    required this.issuePlace,
    required this.nationality,
  });

  @override
  String toString() {
    return 'DocumentModel{' ' cardType: $cardType,' ' id: $id,' ' name: $name,' ' gender: $gender,' +
        ' birthDay: $birthDay,' +
        ' recentLocation: $recentLocation,' +
        ' originLocation: $originLocation,' +
        ' issueDate: $issueDate,' +
        ' issuePlace: $issuePlace,' +
        ' nationality: $nationality,' +
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'cardType': cardType,
      'id': id,
      'name': name,
      'gender': gender,
      'birthDay': birthDay,
      'recentLocation': recentLocation,
      'originLocation': originLocation,
      'issueDate': issueDate,
      'issuePlace': issuePlace,
      'nationality': nationality,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      cardType: map['card_type'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      gender: map['gender'] as String,
      birthDay: map['birth_day'] as String,
      recentLocation: map['recent_location'] as String,
      originLocation: map['origin_location'] as String,
      issueDate: map['issue_date'] as String,
      issuePlace: map['issue_place'] as String,
      nationality: map['nationality'] as String,
    );
  }
}
