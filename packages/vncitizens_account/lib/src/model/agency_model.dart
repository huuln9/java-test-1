class AgencyModel {
  String id;
  String name;
  int status;
  String deploymentId;

  AgencyModel({
    required this.id,
    required this.name,
    required this.status,
    required this.deploymentId,
  });

  @override
  String toString() {
    return 'AgencyModel{' ' id: $id,' ' name: $name,' ' status: $status,' ' deploymentId: $deploymentId,' + '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'deploymentId': deploymentId,
    };
  }

  factory AgencyModel.fromMap(Map<String, dynamic> map) {
    return AgencyModel(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as int,
      deploymentId: map['deploymentId'] as String,
    );
  }
}