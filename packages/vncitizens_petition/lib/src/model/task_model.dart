class TaskModel {
  final String? id;
  final AssigneeModel? assignee;
  final int? sendFrom;
  final List<AssigneeModel>? candidateUser;
  final int? isFirst;
  final int? isLast;
  final int? isCurrent;
  final String? dueDate;
  final String? createdDate;
  final String? updatedDate;
  final ActivitiTaskModel? activitiTask;
  final ProcessDefinitionTask? bpmProcessDefinitionTask;
  final bool? previousTaskIsLate;

  TaskModel(
      {this.id,
      this.assignee,
      this.sendFrom,
      this.candidateUser,
      this.isFirst,
      this.isLast,
      this.isCurrent,
      this.dueDate,
      this.createdDate,
      this.updatedDate,
      this.activitiTask,
      this.bpmProcessDefinitionTask,
      this.previousTaskIsLate});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        assignee: json['assignee'] != null
            ? AssigneeModel.fromJson(json['assignee'])
            : null,
        sendFrom: json['sendFrom'],
        candidateUser: (json['candidateUser'] as List<dynamic>?)
            ?.map((e) => AssigneeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isFirst: json['isFirst'],
        isLast: json['isLast'],
        isCurrent: json['isCurrent'],
        dueDate: json['dueDate'],
        createdDate: json['createdDate'],
        updatedDate: json['updatedDate'],
        activitiTask: json['activitiTask'] != null
            ? ActivitiTaskModel.fromJson(json['activitiTask'])
            : null,
        bpmProcessDefinitionTask: json['bpmProcessDefinitionTask'] != null
            ? ProcessDefinitionTask.fromJson(json['bpmProcessDefinitionTask'])
            : null,
        previousTaskIsLate: json['previousTaskIsLate']);
  }
}

class AssigneeModel {
  final String? id;
  final String? fullname;
  final AccountModel? account;
  // final AgencyModel? agency;

  AssigneeModel({this.id, this.fullname, this.account});
  factory AssigneeModel.fromJson(Map<String, dynamic> json) {
    return AssigneeModel(
      id: json['id'],
      account: json['parentId'] != null
          ? AccountModel.fromJson(json['parentId'])
          : null,
      fullname: json['fullname'],
      // agency: json['agency'] != null
      //     ? AgencyModel.fromJson(json['agency'])
      //     : null
    );
  }
}

class AccountModel {
  final String? id;
  final List<UsernameModel>? username;

  AccountModel({this.id, this.username});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
        id: json['id'],
        username: (json['username'] as List<dynamic>?)
            ?.map((e) => UsernameModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

class UsernameModel {
  final String? value;

  UsernameModel({this.value});
  factory UsernameModel.fromJson(Map<String, dynamic> json) {
    return UsernameModel(value: json['value']);
  }
}

// class AgencyModel {
//   final String? id;
//   final List<NameModel>? name;
//   final String? code;
//   final AgencyModel? parent;
//   final List<AgencyModel>? ancestors;

//   AgencyModel({this.id, this.name, this.code, this.parent, this.ancestors});

//   factory AgencyModel.fromJson(Map<String, dynamic> json) {
//     return AgencyModel(
//       id: json['id'],
//       name: (json['name'] as List<dynamic>?)
//           ?.map((e) => NameModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       code: json['code'],
//       parent:
//           json['parent'] != null ? AgencyModel.fromJson(json['parent']) : null,
//       ancestors: (json['name'] as List<dynamic>?)
//           ?.map((e) => AgencyModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

class NameModel {
  final int? languageId;
  final String? name;

  NameModel({this.languageId, this.name});
  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(languageId: json['languageId'], name: json['name']);
  }
}

class ActivitiTaskModel {
  final String? id;
  final String? status;

  ActivitiTaskModel({this.id, this.status});
  factory ActivitiTaskModel.fromJson(Map<String, dynamic> json) {
    return ActivitiTaskModel(id: json['id'], status: json['status']);
  }
}

class TimesheetModel {
  final String? id;
  final String? name;

  TimesheetModel({this.id, this.name});

  factory TimesheetModel.fromJson(Map<String, dynamic> json) {
    return TimesheetModel(id: json['id'], name: json['name']);
  }
}

class ProcessDefinitionTask {
  final String? id;
  final TimesheetModel? name;
  final TimesheetModel? timesheet;
  // final double? processingTime;
  // final String? processingTimeUnit;
  // final int? processingTimeDayOff;

  ProcessDefinitionTask({
    this.id,
    this.name,
    this.timesheet,
  });

  factory ProcessDefinitionTask.fromJson(Map<String, dynamic> json) {
    return ProcessDefinitionTask(
      id: json['id'],
      name: json['name'] != null ? TimesheetModel.fromJson(json['name']) : null,
      timesheet: json['timesheet'] != null
          ? TimesheetModel.fromJson(json['timesheet'])
          : null,
      // processingTime: json['processingTime'],
      // processingTimeUnit: json['processingTimeUnit'],
      // processingTimeDayOff: json['processingTimeDayOff']
    );
  }
}
