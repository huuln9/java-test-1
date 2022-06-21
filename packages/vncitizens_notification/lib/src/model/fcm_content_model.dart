import 'dart:convert';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/model/agency_model.dart';
import 'package:vncitizens_notification/src/model/fcm_viewer_model.dart';

class FcmContentModel {
  FcmContentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.fcmViewer,
    required this.data,
    required this.fromAgency,
    required this.sentDate,
    required this.deploymentId,
  });

  late String id;
  late String title;
  late String content;
  late FcmViewerModel fcmViewer;
  late dynamic data;
  late AgencyModel fromAgency;
  late DateTime sentDate;
  late String deploymentId;

  FcmContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    fcmViewer = FcmViewerModel.fromJson(json['fcmViewer']);
    data = json['data'];
    fromAgency = AgencyModel.fromJson(json['fromAgency']);
    sentDate = TimeZoneHelper.convert(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['sentDate']));
    deploymentId = json['deploymentId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['content'] = content;
    _data['fcmViewer'] = fcmViewer.toJson();
    // _data['data'] = data.toJson();
    _data['fromAgency'] = fromAgency.toJson();
    _data['sentDate'] = sentDate.toIso8601String();
    _data['deploymentId'] = deploymentId;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
