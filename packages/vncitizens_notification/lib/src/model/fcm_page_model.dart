import 'dart:convert';

import 'package:vncitizens_notification/src/model/fcm_content_model.dart';

class FcmPageModel {
  FcmPageModel({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  late List<FcmContentModel> content;
  late Pageable pageable;
  late int totalElements;
  late int totalPages;
  late bool last;
  late int size;
  late int number;
  late Sort sort;
  late int numberOfElements;
  late bool first;
  late bool empty;

  FcmPageModel.fromJson(Map<String, dynamic> json) {
    content =
        List.from(json['content']).map((e) => FcmContentModel.fromJson(e)).toList();
    pageable = Pageable.fromJson(json['pageable']);
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = Sort.fromJson(json['sort']);
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content.map((e) => e.toJson()).toList();
    _data['pageable'] = pageable.toJson();
    _data['totalElements'] = totalElements;
    _data['totalPages'] = totalPages;
    _data['last'] = last;
    _data['size'] = size;
    _data['number'] = number;
    _data['sort'] = sort.toJson();
    _data['numberOfElements'] = numberOfElements;
    _data['first'] = first;
    _data['empty'] = empty;
    return _data;
  }

  @override
  String toString() => json.encode(toJson());
}

class Pageable {
  Pageable({
    required this.sort,
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  late Sort sort;
  late int offset;
  late int pageNumber;
  late int pageSize;
  late bool paged;
  late bool unpaged;

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = Sort.fromJson(json['sort']);
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sort'] = sort.toJson();
    _data['offset'] = offset;
    _data['pageNumber'] = pageNumber;
    _data['pageSize'] = pageSize;
    _data['paged'] = paged;
    _data['unpaged'] = unpaged;
    return _data;
  }
}

class Sort {
  Sort({
    required this.unsorted,
    required this.sorted,
    required this.empty,
  });

  late bool unsorted;
  late bool sorted;
  late bool empty;

  Sort.fromJson(Map<String, dynamic> json) {
    unsorted = json['unsorted'];
    sorted = json['sorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['unsorted'] = unsorted;
    _data['sorted'] = sorted;
    _data['empty'] = empty;
    return _data;
  }
}
