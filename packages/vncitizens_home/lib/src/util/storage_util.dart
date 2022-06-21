import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_home/src/config/home_app_config.dart';

class StorageUtil {
  static final _storage = GetStorage(HomeAppConfig.storageBox);

  static Future<void> writeShowedUpdate(bool value) async {
    await _storage.write("showedUpdate", value);
  }

  static bool readShowedUpdate() {
    return _storage.read("showedUpdate");
  }

  static Future<void> removeShowedUpdate() async {
    await _storage.remove("showedUpdate");
  }
}