import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_account/src/binding/all_binding.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_account/src/widget/change_email.dart';
import 'package:vncitizens_account/src/widget/change_passwrod.dart';
import 'package:vncitizens_account/src/widget/change_phone.dart';
import 'package:vncitizens_account/src/widget/change_phone_otp.dart';
import 'package:vncitizens_account/src/widget/document.dart';
import 'package:vncitizens_account/src/widget/face_username.dart';
import 'package:vncitizens_account/src/widget/login.dart';
import 'package:vncitizens_account/src/widget/register_after_document.dart';
import 'package:vncitizens_account/src/widget/register_after_document_otp.dart';
import 'package:vncitizens_account/src/widget/register_otp.dart';
import 'package:vncitizens_account/src/widget/register.dart';
import 'package:vncitizens_account/src/widget/reset_pass_email.dart';
import 'package:vncitizens_account/src/widget/reset_pass_email_otp.dart';
import 'package:vncitizens_account/src/widget/reset_pass_new_pass.dart';
import 'package:vncitizens_account/src/widget/reset_pass_sms.dart';
import 'package:vncitizens_account/src/widget/reset_pass_sms_otp.dart';
import 'package:vncitizens_account/src/widget/update_document.dart';
import 'package:vncitizens_account/src/widget/user_detail.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AccountAppConfig.packageName);
  GetPageCenter.add(GetPage(name: AccountRouteConfig.loginRoute, page: () => const Login(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.loginAppRoute, page: () => const Login(initApp: true), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.registerRoute, page: () => const Register(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.userDetailRoute, page: () => const UserDetail(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.registerOtpRoute, page: () => const RegisterOtp(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.changePhoneNumberRoute, page: () => const ChangePhone(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.changePhoneOtpRoute, page: () => const ChangePhoneOtp(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.changeEmailRoute, page: () => const ChangeEmail(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.changePasswordRoute, page: () => const ChangePassword(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.resetPasswordSmsRoute, page: () => const ResetPassSms(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.resetPasswordSmsOtpRoute, page: () => const ResetPassSmsOtp(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.resetPasswordNewPassRoute, page: () => const ResetPassNewPass(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.resetPasswordEmailOtpRoute, page: () => const ResetPassEmailOtp(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.resetPasswordEmailRoute, page: () => const ResetPassEmail(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.documentRoute, page: () => const Document(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.registerAfterDocumentRoute, page: () => const RegisterAfterDocument(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.registerAfterDocumentOtpRoute, page: () => const RegisterAfterDocumentOtp(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.updateDocumentRoute, page: () => const UpdateDocument(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: AccountRouteConfig.faceUsernameRoute, page: () => const FaceUsername(), binding: AllBinding()));
}
