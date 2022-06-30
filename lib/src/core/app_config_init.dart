import 'dart:developer' as dev;

import 'package:vncitizens_common/vncitizens_common.dart';
import '../config/app_config.dart';

initAppConfig() async {
  dev.log('initialize config', name: AppConfig.packageName);
  ConfigService configService = ConfigService();
  configService.baseUrl = AppConfig.iscsBaseUrl;
  Response response = await configService.getPublicConfigurationAsKeyValue(
      [AppConfig.configCode],
      deploymentId: AppConfig.deploymentId);

  if (response.statusCode == 200) {
    dev.log('load remote config with response body: ${response.body}',
        name: AppConfig.packageName);
    await _storeRemoteConfig(response.body?[AppConfig.configCode]?["parameters"]);
  } else {
    throw DetailsException("Failed to load application config", details: {
      'responseCode': response.statusCode,
      'responseBody': response.bodyString
    });
  }
}

Future<void> _storeRemoteConfig(dynamic config) async {
  List<String> initialized = [];
  if (config is Map) {
    for (MapEntry<dynamic, dynamic> entry in config.entries) {
      var arr = entry.key.toString().split(".");
        var boxName = arr.first;
        var storeKey = arr.length != 2 || arr[1].isEmpty ? AppConfig.defaultConfigKey : arr[1];
        if (!initialized.contains(boxName)) {
          initialized.add(boxName);
          await GetStorage.init(boxName);
          dev.log("INIT STORAGE " + boxName + " SUCCESSFULLY !!!", name: AppConfig.packageName);
        }
        await GetStorage(boxName).write(storeKey, entry.value);
        // dev.log('store remote config box $boxName, key $storeKey', name: AppConfig.packageName);
    }
  } else {
    dev.log('remote config is not stored because it is not a map or empty',
        name: AppConfig.packageName);
  }
}
