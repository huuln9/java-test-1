class HCMTagResource {
  final String name;
  final String id;
  bool isSelected = false;
  bool isSchool = false;
  HCMTagResource({required this.name, required this.id});

  factory HCMTagResource.fromJson(Map<String, dynamic> json) {
    return HCMTagResource(id: json['id'], name: json['name']);
  }
}
