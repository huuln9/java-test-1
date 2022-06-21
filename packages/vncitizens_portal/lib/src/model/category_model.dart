class CategoryModel {
  int id;
  String? name;
  String resource;
  bool active = false;

  CategoryModel({required this.id, this.name, required this.resource});

  static List<CategoryModel> fromArray(List<dynamic> jsonArr, String resource) {
    List<CategoryModel> listCategory = [];
    for (var json in jsonArr) {
      listCategory.add(
        CategoryModel(
          id: json['ChuyenMucID'] as int,
          name: json['TenChuyenMuc'] ?? '',
          resource: resource,
        ),
      );
    }
    return listCategory;
  }

  // factory CategoryModel.fromJson(Map<String, dynamic> json) {
  //   return CategoryModel(
  //     id: json['ChuyenMucID'] as int,
  //     name: json['TenChuyenMuc'] ?? '',
  //     resource: '',
  //   );
  // }
}
