import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vnpt_vcall/manager/manager_enum.dart';
import 'package:vnpt_vcall/vnpt_vcall.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';
import '../model/vcall_model.dart';

class VCallUtil {
  static String _uuid = "";

  static Future<void> registerDevice(String phoneNumber) async {
    _uuid = phoneNumber.replaceAll("+", "");
    // _uuid = await vCallManager.createUUID();
    Map<String, dynamic> res = GetStorage(AppConfig.storageBox).read(AppConfig.vCallStorageKey);
    VCallModel vCallModel = VCallModel.fromMap(res);
    dev.log("TOKEN CUSTOMER: " + vCallModel.tokenCustomer, name: AppConfig.packageName);
    dev.log("UUID: " + _uuid, name: AppConfig.packageName);
    VCallResponse response = await vCallManager.registerDevice(
      //tokenCustomer
        tokenCustomer: vCallModel.tokenCustomer,
        displayName: "vnCitizens",
        uuidClient: _uuid,
        useVChat: false);
    dev.log(response.message, name: AppConfig.packageName);
    await Hive.box(AppConfig.storageBox).put("uuid", _uuid);
    dev.log("Set uuid to hive box: " + _uuid, name: AppConfig.packageName);
  }

  static createVCall() {
    dev.log("CREATE CALL");
    dev.log("UUID: " + _uuid != "" ? _uuid : Hive.box(AppConfig.storageBox).get("uuid"), name: AppConfig.packageName);
    dev.log("Full Name: " + (AuthUtil.fullName ?? "Unknown"), name: AppConfig.packageName);
    Map<String, dynamic> response = GetStorage(AppConfig.storageBox).read(AppConfig.vCallStorageKey);
    VCallModel vCallModel = VCallModel.fromMap(response);
    vCallManager.createVCall(
      avatarReceiver: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          vCallModel.avatarReceiver,
          height: 150,
          width: 150,
        ),
      ),
      tokenCustomer: vCallModel.tokenCustomer,
      caller: _uuid != "" ? _uuid : Hive.box(AppConfig.storageBox).get("uuid"),
      dest: vCallModel.dest,
      typeCall: TypeCall.Video,
      callerName: AuthUtil.fullName ?? "Unknown",
      context: Get.context as BuildContext,
      desName: vCallModel.desName,
      dataOptions: vCallModel.dataOptions,
      callToCallCenter: true,
    ).then((value) => dev.log(value?.message ?? ""));
  }

  static Future<void> unRegisterDevice() async {
    Map<String, dynamic> res = GetStorage(AppConfig.storageBox).read(AppConfig.vCallStorageKey);
    VCallModel vCallModel = VCallModel.fromMap(res);
    VCallResponse response = await vCallManager.unRegisterDevice(tokenCustomer: vCallModel.tokenCustomer);
    dev.log(response.message, name: AppConfig.packageName);
    await Hive.box(AppConfig.storageBox).delete("uuid");
    dev.log("Delete uuid successfully", name: AppConfig.packageName);
  }
}