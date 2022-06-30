import 'package:flutter_vnpt_map/model/label.dart';

class Data {
  String? geomEncoded;
  List<Label>? labels;

  Data({
    this.geomEncoded,
    this.labels,
  });

  Data.fromJson(Map<String, dynamic> json) {
    geomEncoded = json['geom_encoded'];
    if (json['labels'] != null) {
      labels = <Label>[];
      json['labels'].forEach((v) {
        labels!.add(new Label.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geom_encoded'] = this.geomEncoded;
    if (this.labels != null) {
      data['labels'] = this.labels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
