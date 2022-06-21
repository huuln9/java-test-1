import 'package:vncitizens_garbage_schedule/src/model/garbage_schedule_model.dart';

class GarbageScheduleGroupModel {
  String? id;
  String name;
  List<GarbageScheduleModel> group;

  GarbageScheduleGroupModel({this.id, required this.name, required this.group});
}
