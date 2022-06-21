import 'package:vncitizens_common/vncitizens_common.dart';

class AccountAppConfig {
  /// your package name
  static const String packageName = "vncitizens_account";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  /// sms configuration id storage key
  static const String smsConfigIdStorageKey = "smsConfigId";

  /// email configuration id storage key
  static const String emailConfigIdStorageKey = "emailConfigId";

  /// citizen issuer tag id storage key
  static const String citizenIssuerTagIdStorageKey = "citizenIssuerTagId";

  /// place type category id storage key
  static const String placeTypeCategoryIdStorageKey = "placeTypeCategoryId";

  /// default nation id storage key
  static const String defaultNationIdStorageKey = "defaultNationId";

  static int get loginFailedCount1 {
    return GetStorage(storageBox).read("loginConfig")["x"];
  }

  static int get loginFailedMaxCountdown1 {
    return GetStorage(storageBox).read("loginConfig")["p"];
  }

  static int get loginFailedCount2 {
    return GetStorage(storageBox).read("loginConfig")["y"];
  }

  static int get loginFailedMaxCountdown2 {
    return GetStorage(storageBox).read("loginConfig")["q"];
  }

  static String? get loginLogoUrl {
    return GetStorage(storageBox).read("config")["loginLogoUrl"];
  }

  static bool? get requireEmail {
    return GetStorage(storageBox).read("config")["requireEmail"];
  }

  static String? get remoteInitialRoute {
    return GetStorage("flutter_vncitizens").read("initialRoute");
  }

  static String? get remoteAppCopyright {
    return GetStorage("flutter_vncitizens").read("copyright");
  }

  static bool? get appRequireLogin {
    return GetStorage("flutter_vncitizens").read("requireLogin");
  }

  static bool? get isIntegratedEKYC {
    return GetStorage("vncitizens_setting").read("integratedEKYC");
  }
}
