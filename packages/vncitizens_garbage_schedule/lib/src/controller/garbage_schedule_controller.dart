import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_garbage_schedule/src/config/app_config.dart';
import 'package:vncitizens_garbage_schedule/src/model/garbage_schedule_group_model.dart';
import 'package:vncitizens_garbage_schedule/src/model/garbage_schedule_model.dart';
import 'package:vncitizens_garbage_schedule/src/model/id_name_model.dart';

class GarbageScheduleController extends GetxController {
  final textController = TextEditingController();
  FocusNode textFocus = FocusNode();
  RxBool isFocus = false.obs;
  RxBool isLoading = false.obs;
  RxList<GarbageScheduleGroupModel> data = <GarbageScheduleGroupModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    log("INIT GARBAGE SCHEDULE CONTROLLER", name: AppConfig.packageName);

    textFocus.addListener(_onFocusChange);

    await getAndHandleData();
  }

  void _onFocusChange() => isFocus.value = textFocus.hasFocus;

  Future<void> getAndHandleData({String? keyword}) async {
    isLoading.value = true;

    Map<String, dynamic> place =
        GetStorage(AppConfig.storageBox).read(AppConfig.place);

    List<GarbageScheduleModel> garbageScheduleFull;
    if (keyword != null) {
      garbageScheduleFull = await _getFullGarbageSchedule(
        provinceId: place['province']['id'],
        nationId: place['nation']['id'],
        keyword: keyword,
      );
    } else {
      garbageScheduleFull = await _getFullGarbageSchedule(
          provinceId: place['province']['id'], nationId: place['nation']['id']);
    }

    List<IdNameModel> districts = _distinctDistrict(garbageScheduleFull);

    _groupDataByDistricts(garbageScheduleFull, districts);

    isLoading.value = false;
  }

  Future<List<GarbageScheduleModel>> _getFullGarbageSchedule({
    required String provinceId,
    required String nationId,
    String? keyword,
  }) async {
    Response response;
    if (keyword != null) {
      response = await VnccService().getFullGarbageSchedule(
          provinceId: provinceId, nationId: nationId, keyword: keyword);
    } else {
      response = await VnccService()
          .getFullGarbageSchedule(provinceId: provinceId, nationId: nationId);
    }

    if (response.statusCode == 200) {
      List<GarbageScheduleModel> list = [];
      response.body.forEach((item) {
        list.add(GarbageScheduleModel.fromMap(item));
      });
      return list;
    } else {
      throw "GET FULL GARBAGE SCHEDULE FAILURE";
    }
  }

  List<IdNameModel> _distinctDistrict(List<GarbageScheduleModel> listFull) {
    List<IdNameModel> districts = [];
    // list check id is exists in list districts
    List<String> idAddeds = [];
    for (final e in listFull) {
      if (!idAddeds.contains(e.place.district!.id)) {
        districts.add(e.place.district!);
        idAddeds.add(e.place.district!.id);
      }
    }
    return districts;
  }

  void _groupDataByDistricts(
      List<GarbageScheduleModel> listFull, List<IdNameModel> districts) {
    data.value = [];

    List<GarbageScheduleGroupModel> garbageScheduleGroup = [];

    for (final e in districts) {
      List<GarbageScheduleModel> listByDistricts = [];
      for (final element in listFull) {
        if (element.place.district!.id == e.id) {
          listByDistricts.add(element);
        }
      }
      garbageScheduleGroup.add(GarbageScheduleGroupModel(
          id: e.id, name: e.name ?? '', group: listByDistricts));
    }
    data.addAll(garbageScheduleGroup);
  }

  @override
  void dispose() {
    super.dispose();
    textFocus.removeListener(_onFocusChange);
    textFocus.dispose();
  }
}
