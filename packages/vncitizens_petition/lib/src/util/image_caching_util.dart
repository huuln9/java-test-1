import 'dart:typed_data';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';

class ImageCachingUtil {
  static Future<Uint8List?> get(String id) async {
    return Hive.box(AppConfig.storageBox).get(id);
  }

  static Future<void> set(String id, Uint8List bytes) async {
    await Hive.box(AppConfig.storageBox).put(id, bytes);
  }

  static Future<void> delete(String id) async {
    await Hive.box(AppConfig.storageBox).delete(id);
  }
}
