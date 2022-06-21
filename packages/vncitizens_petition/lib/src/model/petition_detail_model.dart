import 'package:vncitizens_petition/src/model/task_model.dart';
import 'package:vncitizens_petition/src/util/date_util.dart';

class PetitionDetailModel {
  String? id;
  final String? title;
  final String? code;
  final String? description;
  final int? status;
  final String? statusDescription;

  //tag
  final TagModel? tag;
  final String? takePlaceOn;
  final String? receiptDate;
  final String? createdDate;
  final String? dueDate;
  //agency
  AgencyModel? agency;
  //receptionMethod
  final String? receptionMethodDescription;
  //takePlaceAt
  final TakePlaceAtModel? takePlaceAt;
  //reporterLocation
  final ReporterLocationModel? reporterLocation;
  //reporter
  final ReporterModel? reporter;
  //file
  final List<FileModel>? file;
  final String? thumbnailId;
  final String? isPublic;
  final String? isAnonymous;
  final String? requiredSecret;
  final String? processInstanceId;
//reaction
  final ReactionModel? reaction;
  dynamic processDefinition;
//shared
//task
  final List<TaskModel>? task;
  final int? claimStatus;
  final bool? viewOnly;
  final String? typeRequest;
  final int? progress;
  final bool? canReassign;
  final int? spam;
  final dynamic shared;
  final ResultModel? result;
  final List<ResultModel>? resultArray;
  bool? sendSms;
  String? callId;
  String? deploymentId;
  String? receptionMethod;

  double get rating {
    if (countRate == 0) {
      return 0.0;
    }
    var point = 0.0;
    if (reaction != null) {
      point += reaction!.satisfied! * 3.0;
      point += reaction!.normal! * 2.0;
      point += reaction!.unsatisfied! * 1.0;
    }

    return point / countRate;
  }

  int get countRate {
    var count = 0;
    if (reaction != null) {
      var c = reaction!.satisfied! + reaction!.normal! + reaction!.unsatisfied!;
      if (c > 0) {
        count = c;
      }
    }

    return count;
  }

  PetitionDetailModel(
      {this.id,
      this.title,
      this.code,
      this.description,
      this.status,
      this.statusDescription,
      this.tag,
      this.takePlaceOn,
      this.receiptDate,
      this.createdDate,
      this.dueDate,
      this.receptionMethodDescription,
      this.thumbnailId,
      this.isPublic,
      this.isAnonymous,
      this.requiredSecret,
      this.processInstanceId,
      this.task,
      this.claimStatus,
      this.viewOnly,
      this.typeRequest,
      this.progress,
      this.canReassign,
      this.spam,
      this.shared,
      this.takePlaceAt,
      this.reporterLocation,
      this.file,
      this.reaction,
      this.reporter,
      this.result,
      this.resultArray,
      this.agency,
      this.callId,
      this.deploymentId,
      this.processDefinition,
      this.receptionMethod,
      this.sendSms});

  factory PetitionDetailModel.fromJson(Map<String, dynamic> json) {
    return PetitionDetailModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        description: json['description'],
        status: json['status'],
        statusDescription: json['statusDescription'],
        tag: json['tag'] != null ? TagModel.fromJson(json['tag']) : null,
        takePlaceOn: json['takePlaceOn'],
        receiptDate: json['receiptDate'],
        createdDate: json['createdDate'],
        dueDate: json['dueDate'],
        receptionMethodDescription: json['receptionMethodDescription'],
        thumbnailId: json['thumbnailId'],
        isPublic: json['isPublic'],
        isAnonymous: json['isAnonymous'],
        requiredSecret: json['requiredSecret'],
        processInstanceId: json['processInstanceId'],
        task: (json['task'] as List<dynamic>?)
            ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        claimStatus: json['claimStatus'],
        viewOnly: json['viewOnly'],
        typeRequest: json['typeRequest'],
        progress: json['progress'],
        canReassign: json['canReassign'],
        spam: json['spam'],
        shared: json['shared'],
        takePlaceAt: json['takePlaceAt'] != null
            ? TakePlaceAtModel.fromJson(json['takePlaceAt'])
            : null,
        reporterLocation: json['reporterLocation'] != null
            ? ReporterLocationModel.fromJson(json['reporterLocation'])
            : null,
        file: (json['file'] as List<dynamic>?)
            ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        reaction: json['reaction'] != null
            ? ReactionModel.fromJson(json['reaction'])
            : null,
        reporter: json['reporter'] != null
            ? ReporterModel.fromJson(json['reporter'])
            : null,
        result: json['result'] != null
            ? ResultModel.fromJson(json['result'])
            : null,
        resultArray: (json['resultArray'] as List<dynamic>?)
            ?.map((e) => ResultModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    _data['takePlaceOn'] = takePlaceOn;
    _data['agency'] = agency!.toJson();
    _data['takePlaceAt'] = takePlaceAt.toString();
    _data['reporterLocation'] = reporterLocation!.toJson();
    _data['file'] = file!.map((e) => e.toJson()).toList();
    _data['reporter'] = reporter!.toJson();
    _data['isPublic'] = isPublic;
    _data['isAnonymous'] = isAnonymous;
    _data['requiredSecret'] = requiredSecret;
    _data['sendSms'] = sendSms;
    _data['callId'] = callId;
    _data['requiredSecret'] = requiredSecret;
    return _data;
  }
}

class TagModel {
  final String? id;
  final String? parentId;
  final String? name;

  TagModel({this.id, this.parentId, this.name});
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      parentId: json['parentId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class AgencyModel {
  final String? id;
  final String? name;
  final String? code;

  AgencyModel({this.id, this.name, this.code});

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(id: json['id'], name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class TakePlaceAtModel {
  final double? latitude;
  final double? longitude;
  final String? fullAddress;
  final List<PlaceModel>? place;

  TakePlaceAtModel(
      {this.latitude, this.longitude, this.fullAddress, this.place});

  factory TakePlaceAtModel.fromJson(Map<String, dynamic> json) {
    return TakePlaceAtModel(
        latitude: json['latitude'],
        longitude: json['longitude'],
        fullAddress: json['fullAddress'],
        place: (json['place'] as List<dynamic>?)
            ?.map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['fullAddress'] = fullAddress;
    _data['place'] = place!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PlaceModel {
  final String? id;
  final String? typeId;
  final String? name;

  PlaceModel({this.id, this.typeId, this.name});
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
        id: json['id'], name: json['name'], typeId: json['typeId']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['typeId'] = typeId;
    _data['name'] = name;
    return _data;
  }
}

class ReporterLocationModel {
  final double? latitude;
  final double? longitude;
  String? fullAddress;

  ReporterLocationModel({this.latitude, this.longitude, this.fullAddress});

  factory ReporterLocationModel.fromJson(Map<String, dynamic> json) {
    return ReporterLocationModel(
        latitude: json['latitude'], longitude: json['longitude']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['fullAddress'] = fullAddress;
    return _data;
  }
}

class ReporterModel {
  final String? fullname;
  final String? phone;
  final String? identityId;
  final int? type;
  String? username;
  String? email;
  ReporterAddressModel? address;
  String? id;

  ReporterModel(
      {this.fullname,
      this.phone,
      this.identityId,
      this.type,
      this.username,
      this.email,
      this.address,
      this.id});

  factory ReporterModel.fromJson(Map<String, dynamic> json) {
    return ReporterModel(
        fullname: json['fullname'],
        phone: json['phone'],
        identityId: json['identityId'],
        type: json['type'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullname'] = fullname;
    _data['phone'] = phone;
    _data['identityId'] = identityId;
    _data['type'] = type;
    _data['username'] = username;
    _data['email'] = email;
    _data['id'] = id;
    _data['address'] = address!.toJson();
    return _data;
  }
}

class ReporterAddressModel {
  final String? address;
  final List<PlaceModel>? place;

  ReporterAddressModel({this.address, this.place});

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address'] = address;
    _data['place'] = place!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class FileModel {
  final String? id;
  final String? updatedDate;
  final String? name;
  final String? path;
  final List<int>? group;

  FileModel({this.id, this.updatedDate, this.name, this.group, this.path});
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
        id: json['id'],
        updatedDate: json['updatedDate'],
        name: json['name'] ?? json['filename'],
        group:
            (json['group'] as List<dynamic>?)?.map((e) => e as int).toList());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['updatedDate'] = DateTime.now().toIso8601String();
    _data['name'] = name;
    _data['group'] = "1";
    return _data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['updatedDate'] = DateTime.now().toIso8601String();
    _data['name'] = name;
    _data['group'] = ["1"];
    return _data;
  }
}

class ReactionModel {
  final int? satisfied;
  final int? normal;
  final int? unsatisfied;

  ReactionModel({this.satisfied, this.normal, this.unsatisfied});

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
        satisfied: json['satisfied'],
        normal: json['normal'],
        unsatisfied: json['unsatisfied']);
  }
}

class ResultModel {
  final String? content;
  final String? date;
  final AgencyModel? agency;
  final bool? isPublic;
  final bool? approved;
  final bool? sendSms;
  final bool? done;
  final bool? ubmttqResult;

  ResultModel(
      {this.content,
      this.date,
      this.agency,
      this.isPublic,
      this.approved,
      this.sendSms,
      this.done,
      this.ubmttqResult});

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
        content: json['content'],
        date: json['date'],
        agency: json['agency'] != null
            ? AgencyModel.fromJson(json['agency'])
            : null,
        isPublic: json['isPublic'],
        approved: json['approved'],
        sendSms: json['sendSms'],
        done: json['done'],
        ubmttqResult: json['ubmttqResult']);
  }
}
