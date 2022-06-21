class TagInfoModel {
  TagInfoModel({required this.id, this.parent});

  late final String id;
  late final String? parent;

  TagInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    if (parent != null && parent!.isNotEmpty) {
      _data['parent'] = parent;
    }
    return _data;
  }
}
