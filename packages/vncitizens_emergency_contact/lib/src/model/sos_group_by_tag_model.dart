import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class SosGroupByTagModel {
  String id;
  String? name;
  String? description;
  List<SosItemModel>? contacts;

  SosGroupByTagModel({
    required this.id,
    this.name,
    this.description,
    this.contacts,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SosGroupByTagModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          contacts == other.contacts);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ contacts.hashCode;

  @override
  String toString() {
    return 'SosGroupByTagModel{' ' id: $id,' ' name: $name,' ' description: $description,' ' contacts: $contacts,' +
        '}';
  }

  SosGroupByTagModel copyWith({
    String? id,
    String? name,
    String? description,
    List<SosItemModel>? contacts,
  }) {
    return SosGroupByTagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      contacts: contacts ?? this.contacts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'contacts': contacts,
    };
  }

  factory SosGroupByTagModel.fromMap(Map<String, dynamic> map) {
    return SosGroupByTagModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      contacts: map['contacts'] as List<SosItemModel>,
    );
  }
}