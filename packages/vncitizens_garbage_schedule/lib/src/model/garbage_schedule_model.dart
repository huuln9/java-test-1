import 'package:vncitizens_garbage_schedule/src/model/place_model.dart';

class GarbageScheduleModel {
  String id;
  String street;
  String? description;
  String? period;
  String? thumbnailId;
  PlaceModel place;
  int status;

  GarbageScheduleModel({
    required this.id,
    required this.street,
    this.description,
    this.period,
    this.thumbnailId,
    required this.place,
    required this.status,
  });

  factory GarbageScheduleModel.fromMap(Map<String, dynamic> map) {
    return GarbageScheduleModel(
      id: map['id'] as String,
      street: map['street'] as String,
      description: map['description'] ?? '',
      period: map['period'] ?? '',
      thumbnailId: map['thumbnailId'] ?? '',
      place: PlaceModel.fromMap(map['place']),
      status: map['status'] as int,
    );
  }
}
