class QueueModel {
  String name;
  String id;
  String description;
  String coQuan;
  String officials;
  int? processingNumber;
  int? userNumber;
  String numberId;

  QueueModel(
      {required this.name,
      required this.id,
      required this.description,
      required this.coQuan,
      required this.officials,
      this.processingNumber,
      this.userNumber,
      required this.numberId});

  factory QueueModel.fromMap(Map<String, dynamic> map) {
    return QueueModel(
        id: map['queue'][0]['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        processingNumber: map['queue'][0]['processingNumber'] as int,
        userNumber: map['queue'][0]['userNumber']?['number'],
        numberId: map['queue'][0]['userNumber']?['id'] as String,
        coQuan: map['queue'][0]['name'] as String,
        officials: map['queue'][0]['officials'] as String);
  }
}
