import 'package:flutter_vnpt_map/model/isochrone_data.dart';

class Isochrones {
  Data? data;

  Isochrones({
    this.data,
  });

  Isochrones.fromJson(Map<String, dynamic> json) {
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

class Isochrone {
  List<Data>? datas;

  Isochrone({this.datas});

  Isochrone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      datas = <Data>[];
      json['data'].forEach((v) {
        datas!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datas != null) {
      data['data'] = this.datas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
