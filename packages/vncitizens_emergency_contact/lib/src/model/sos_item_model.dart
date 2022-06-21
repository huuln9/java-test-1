import 'dart:io';

import 'package:vncitizens_emergency_contact/src/model/id_name_model.dart';

class SosItemModel {
  String id;
  String name;
  String phoneNumber;
  String? image;
  int order;
  int status;
  String deploymentId;
  IdNameModel? tag;
  File? imageFile;

  SosItemModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
    required this.order,
    required this.status,
    required this.deploymentId,
    this.tag,
    this.imageFile
  });


  @override
  String toString() {
    return 'SosItemModel{id: $id, name: $name, phoneNumber: $phoneNumber, image: $image, order: $order, status: $status, deploymentId: $deploymentId, tag: $tag, imageFile: $imageFile}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'image': image,
      'order': order,
      'status': status,
      'deploymentId': deploymentId,
      'tag': tag,
      'imageFile': imageFile?.path ?? ""
    };
  }

  factory SosItemModel.fromMap(Map<String, dynamic> map) {
    return SosItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      image: map['image'] as String,
      order: map['order'] as int,
      status: map['status'] as int,
      deploymentId: map['deploymentId'] as String,
      tag: map['tag'] != null ? IdNameModel.fromMap(map['tag']) : null,
    );
  }

  SosItemModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? image,
    int? order,
    int? status,
    String? deploymentId,
    IdNameModel? tag,
    File? imageFile,
  }) {
    return SosItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      order: order ?? this.order,
      status: status ?? this.status,
      deploymentId: deploymentId ?? this.deploymentId,
      tag: tag ?? this.tag,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  static List<SosItemModel> fromListMap(List<dynamic> maps) {
    List<SosItemModel> lst = [];
    for (var element in maps) {
      lst.add(SosItemModel.fromMap(element));
    }
    return lst;
  }
}