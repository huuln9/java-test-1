class AttachmentModel {
  AttachmentModel({
    required this.id,
    required this.filename,
  });

  late String id;
  late String filename;

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['filename'] = filename;
    return _data;
  }
}
