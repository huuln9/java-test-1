class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_portal";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  /// storage key name
  static const String newsResources = "newsResources";

  static const String size = '15';

  /// router
  static const router = {
    'list': '/vncitizens_portal',
    'detail': '/vncitizens_portal/detail',
  };
}
