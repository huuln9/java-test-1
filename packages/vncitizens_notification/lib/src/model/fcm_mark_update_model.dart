import 'dart:convert';

class FcmMarkUpdateModel {
  FcmMarkUpdateModel({
    this.fcmId,
    required this.viewer,
    this.markAll,
  });

  late List<String>? fcmId;
  late String viewer;
  late bool? markAll;

  FcmMarkUpdateModel.fromJson(Map<String, dynamic> json) {
    fcmId = List.castFrom<dynamic, String>(json['fcmId']);
    viewer = json['viewer'];
    markAll = json['markAll'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fcmId'] = fcmId;
    _data['viewer'] = viewer;
    if (markAll != null && markAll!) {
      _data['markAll'] = markAll;
    }
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
