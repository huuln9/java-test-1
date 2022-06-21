import 'dart:convert';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/model/agency_model.dart';
import 'package:vncitizens_notification/src/model/attachment_model.dart';
import 'package:vncitizens_notification/src/model/system_model.dart';
import 'package:vncitizens_notification/src/model/tag_model.dart';

class FcmInfoModel {
  FcmInfoModel({
    this.id,
    this.configId,
    this.title,
    this.content,
    this.topic,
    this.fcmToken,
    this.status,
    this.sentDate,
    this.startDate,
    this.endDate,
    this.data,
    this.sendingSchedule,
    this.intervalSeconds,
    this.tag,
    this.fromAgency,
    this.fromSystem,
    this.attachment,
    this.createdDate,
    this.provider,
    this.deploymentId,
  });

  late String? id;
  late String? configId;
  late String? title;
  late String? content;
  late List<String>? topic;
  late String? fcmToken;
  late String? status;
  late DateTime? sentDate;
  late DateTime? startDate;
  late DateTime? endDate;
  late dynamic data;
  late String? sendingSchedule;
  late int? intervalSeconds;
  late List<TagModel>? tag;
  late AgencyModel? fromAgency;
  late SystemModel? fromSystem;
  late List<AttachmentModel>? attachment;
  late DateTime? createdDate;
  late String? provider;
  late String? deploymentId;

  FcmInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    configId = json['configId'];
    title = json['title'];
    content = json['content'];
    topic = List.castFrom<dynamic, String>(json['topic']);
    fcmToken = json['fcmToken'];
    status = json['status'];
    if (json['sentDate'] != null) {
      sentDate = TimeZoneHelper.convert(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['sentDate']));
    }
    if (json['startDate'] != null) {
      startDate = TimeZoneHelper.convert(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['startDate']));
    } else {
      startDate = null;
    }
    if (json['endDate'] != null) {
      endDate = TimeZoneHelper.convert(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['endDate']));
    } else {
      endDate = null;
    }
    data = json['data'];
    sendingSchedule = json['sendingSchedule'];
    intervalSeconds = json['intervalSeconds'];
    tag = List.from(json['tag']).map((e) => TagModel.fromJson(e)).toList();
    fromAgency = AgencyModel.fromJson(json['fromAgency']);
    if (json['fromSystem'] != null) {
      fromSystem = SystemModel.fromJson(json['fromSystem']);
    } else {
      fromSystem = null;
    }
    if (json['attachment'] != null) {
      attachment = List.from(json['attachment'])
          .map((e) => AttachmentModel.fromJson(e))
          .toList();
    } else {
      attachment = [];
    }
    if (json['endDate'] != null) {
      createdDate = TimeZoneHelper.convert(
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['createdDate']));
    } else {
      createdDate = null;
    }
    provider = json['provider'];
    deploymentId = json['deploymentId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['configId'] = configId;
    _data['title'] = title;
    _data['content'] = content;
    _data['topic'] = topic;
    _data['fcmToken'] = fcmToken;
    _data['status'] = status;
    _data['sentDate'] = sentDate?.toIso8601String();
    _data['startDate'] = startDate?.toIso8601String();
    _data['endDate'] = endDate?.toIso8601String();
    // _data['data'] = data?.toJson();
    _data['sendingSchedule'] = sendingSchedule;
    _data['intervalSeconds'] = intervalSeconds;
    _data['tag'] = tag?.map((e) => e.toJson()).toList();
    _data['fromAgency'] = fromAgency?.toJson();
    _data['attachment'] = attachment?.map((e) => e.toJson()).toList();
    _data['createdDate'] = createdDate?.toIso8601String();
    _data['provider'] = provider;
    _data['deploymentId'] = deploymentId;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
