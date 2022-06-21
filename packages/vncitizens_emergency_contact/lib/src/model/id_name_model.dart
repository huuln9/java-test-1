class IdNameModel {
  String id;
  String? name;
  String? description;

  IdNameModel({
    required this.id,
    this.name,
    this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdNameModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'IdNameModel{' ' id: $id,' ' name: $name,' ' description: $description,' '}';
  }

  IdNameModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return IdNameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory IdNameModel.fromMap(Map<String, dynamic> map) {
    return IdNameModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }
}
