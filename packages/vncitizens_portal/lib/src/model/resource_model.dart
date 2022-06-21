import 'package:vncitizens_portal/src/model/category_model.dart';

class ResourceModel {
  String name;
  String apiEndpoint;
  String tokenEndpoint;
  String? username;
  String? password;
  bool active;
  List<CategoryModel> defaultCategories;

  ResourceModel({
    required this.name,
    required this.apiEndpoint,
    required this.tokenEndpoint,
    this.username,
    this.password,
    this.active = false,
    this.defaultCategories = const [],
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      name: json['name'] ?? '',
      apiEndpoint: json['apiEndpoint'] ?? '',
      tokenEndpoint: json['tokenEndpoint'] ?? '',
      username: json['username'] as String,
      password: json['password'] as String,
      active: json['active'] as bool,
      defaultCategories: CategoryModel.fromArray(
          json['defaultCategories'], json['apiEndpoint'] ?? ''),
    );
  }
}
