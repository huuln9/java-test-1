class FcmViewerModel {
  FcmViewerModel({
    required this.read,
  });

  late int read;

  FcmViewerModel.fromJson(Map<String, dynamic> json) {
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['read'] = read;
    return _data;
  }
}
