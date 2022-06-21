import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'dart:developer' as dev;

initHive() async {
    var tmpDir = await getTemporaryDirectory();
    dev.log('initialize Hive in directory ${tmpDir.path}', name: AccountAppConfig.packageName);
    await Hive.openBox(AccountAppConfig.storageBox, path: tmpDir.path);
}