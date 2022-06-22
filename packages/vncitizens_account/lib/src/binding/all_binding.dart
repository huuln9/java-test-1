import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/auth_controller.dart';
import 'package:vncitizens_account/src/controller/change_email_controller.dart';
import 'package:vncitizens_account/src/controller/change_password_controller.dart';
import 'package:vncitizens_account/src/controller/change_phone_controller.dart';
import 'package:vncitizens_account/src/controller/change_phone_otp_controller.dart';
import 'package:vncitizens_account/src/controller/document_controller.dart';
import 'package:vncitizens_account/src/controller/face_username_controller.dart';
import 'package:vncitizens_account/src/controller/login_controller.dart';
import 'package:vncitizens_account/src/controller/register_after_doc_controller.dart';
import 'package:vncitizens_account/src/controller/register_after_doc_otp_controller.dart';
import 'package:vncitizens_account/src/controller/register_otp_controller.dart';
import 'package:vncitizens_account/src/controller/register_controller.dart';
import 'package:vncitizens_account/src/controller/reset_pass_email_controller.dart';
import 'package:vncitizens_account/src/controller/reset_pass_email_otp_controller.dart';
import 'package:vncitizens_account/src/controller/reset_pass_new_pass_controller.dart';
import 'package:vncitizens_account/src/controller/reset_pass_sms_controller.dart';
import 'package:vncitizens_account/src/controller/reset_pass_sms_otp_controller.dart';
import 'package:vncitizens_account/src/controller/update_document_controller.dart';
import 'package:vncitizens_account/src/controller/user_detail_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => UserDetailController());
    Get.lazyPut(() => RegisterOtpController());
    Get.lazyPut(() => ChangePhoneController());
    Get.lazyPut(() => ChangePhoneOtpController());
    Get.lazyPut(() => ChangeEmailController());
    Get.lazyPut(() => ChangePasswordController());
    Get.lazyPut(() => ResetPassSmsController());
    Get.lazyPut(() => ResetPassSmsOtpController());
    Get.lazyPut(() => ResetPassNewPassController());
    Get.lazyPut(() => ResetPassEmailOtpController());
    Get.lazyPut(() => ResetPassEmailController());
    Get.lazyPut(() => DocumentController());
    Get.lazyPut(() => RegisterAfterDocumentController());
    Get.lazyPut(() => RegisterAfterDocumentOtpController());
    Get.lazyPut(() => UpdateDocumentController());
    Get.lazyPut(() => FaceUsernameController());
  }
}