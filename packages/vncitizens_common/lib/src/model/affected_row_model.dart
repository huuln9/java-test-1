import 'dart:convert';

class AffectedRowModel {
  AffectedRowModel({
    required this.affectedRows,
  });

  late final int affectedRows;

  AffectedRowModel.fromJson(Map<String, dynamic> json) {
    affectedRows = json['affectedRows'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['affectedRows'] = affectedRows;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}
