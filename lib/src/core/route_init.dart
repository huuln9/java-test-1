import 'dart:developer' as dev;
import '../config/app_config.dart';

initAppRoute() {
  dev.log('initialize route', name: AppConfig.packageName);

  //GetPageCenter.add(GetPage(name: '/setting', page: () => Setting()));
}
