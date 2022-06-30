import 'package:flutter_vnpt_map/model/isochrone_data.dart';

class LabelIsochroneOutput {
  Data? data;

  LabelIsochroneOutput({
    this.data,
  });

  LabelIsochroneOutput.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
