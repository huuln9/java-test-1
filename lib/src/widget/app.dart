import 'dart:developer';

import 'package:digo_common/digo_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/src/config/app_theme_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:vnpt_vcall/manager/vcall_manager.dart';
import 'package:vnpt_vcall/vnpt_vcall.dart';
import 'package:sip_ua/sip_ua.dart';

import '../config/app_config.dart';

class DigoApp extends StatefulWidget {
  const DigoApp({Key? key}) : super(key: key);

  @override
  State<DigoApp> createState() => _DigoAppState();
}

class _DigoAppState extends State<DigoApp>
    with WidgetsBindingObserver
    implements SipUaHelperListener {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureVCall(
        //cho phép show loading khi nhận cuộc gọi
        //nếu không truyền giá trị mặc định là false
        showLoading: true,
        //productMode set true/false sẽ tắt/bật show log của SDK
        //nếu không truyền giá trị mặc định là false
        productMode: false,
        //sdkNative dành cho luồng tích hợp vào app Native
        //nếu không truyền giá trị mặc định là false
        sdkNative: false,
        //luồng xử lý callback event cuộc gọi
        handleCallBackEventVCall: (params) {
          log("ClientApp: Handle CallBackEvent =====");
          log("ClientApp: $params");
        },
        //luồng xử lý callback cuộc gọi nhỡ trên Android
        handleCallBackEventMissedCall: (params) {
          log("ClientApp: Handle EventMissedCall =====");
          log("ClientApp: $params");
        },
        //luồng xử lý callback cuộc gọi nhỡ trên IOS
        handleCallBackRecentCallTap: (dest, video) async {
          log("ClientApp: Handle CallBackRecentCall =====");
          // VCallReponse? vCallResponse = await vCallManager.createVCall();
        },
        //luồng xử lý callback UI cuộc gọi
        //set avatar User
        handleCallBackDataOptions: (params) {
          log("ClientApp: handleCallBackUISDK =====");
          log("ClientApp: $params");
          VCallManager.avatarCaller =
              const Icon(Icons.account_circle, size: 40);
        });
    _bindEventListeners();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppConfig.initialRoute,
      defaultTransition: AppConfig.defaultTransition,
      locale: AppConfig.locale,
      fallbackLocale: AppConfig.fallbackLocale,
      getPages: GetPageCenter.pages,
      theme: AppThemeConfig.customTheme,
      navigatorKey: VCallManager.navigatorKey,
      translationsKeys: Get.translations,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
    );
  }

  void _bindEventListeners() {
    vCallManager.addSipUaHelperListener(this);
  }

  @override
  void callStateChanged(CallState state) {
    callStateChangedCallBack(state, context);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    registrationStateChangeCallBack(state);
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vCallManager.removeSipUaHelperListener(this);
  }
}
