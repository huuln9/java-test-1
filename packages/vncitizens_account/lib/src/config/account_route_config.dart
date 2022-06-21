import 'package:vncitizens_account/src/config/account_app_config.dart' show AccountAppConfig;

class AccountRouteConfig {
  /// login route
  static const String loginRoute = "/${AccountAppConfig.packageName}/login";

  /// login app route
  static const String loginAppRoute = "/${AccountAppConfig.packageName}/login_app";

  /// register route
  static const String registerRoute = "/${AccountAppConfig.packageName}/register";

  /// user detail route
  static const String userDetailRoute = "/${AccountAppConfig.packageName}/user_detail";

  /// change phone number route
  static const String changePhoneNumberRoute = "/${AccountAppConfig.packageName}/change_phone";

  /// register otp route
  static const String registerOtpRoute = "/${AccountAppConfig.packageName}/register_otp";

  /// change phone otp route
  static const String changePhoneOtpRoute = "/${AccountAppConfig.packageName}/change_phone_otp";

  /// change email route
  static const String changeEmailRoute = "/${AccountAppConfig.packageName}/change_email";

  /// change password route
  static const String changePasswordRoute = "/${AccountAppConfig.packageName}/change_password";

  /// reset password sms route
  static const String resetPasswordSmsRoute = "/${AccountAppConfig.packageName}/reset_password_sms";

  /// reset password email route
  static const String resetPasswordEmailRoute = "/${AccountAppConfig.packageName}/reset_password_email";

  /// reset password sms otp route
  static const String resetPasswordSmsOtpRoute = "/${AccountAppConfig.packageName}/reset_password_sms_otp";

  /// reset password email otp route
  static const String resetPasswordEmailOtpRoute = "/${AccountAppConfig.packageName}/reset_password_email_otp";

  /// reset password new pass route
  static const String resetPasswordNewPassRoute = "/${AccountAppConfig.packageName}/reset_password_new_pass";

  /// document route
  static const String documentRoute = "/${AccountAppConfig.packageName}/document";

  /// register after document route
  static const String registerAfterDocumentRoute = "/${AccountAppConfig.packageName}/register_after_document";

  /// register after document otp route
  static const String registerAfterDocumentOtpRoute = "/${AccountAppConfig.packageName}/register_after_document_otp";

  /// update document route
  static const String updateDocumentRoute = "/${AccountAppConfig.packageName}/update_document";

  /// face username route
  static const String faceUsernameRoute = "/${AccountAppConfig.packageName}/face_username";

  /// update user current address
  static const String updateCurrentAddress = "/${AccountAppConfig.packageName}/update_current_address";
}