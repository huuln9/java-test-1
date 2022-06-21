import 'package:vncitizens_camera/src/core/route_init.dart';
import 'package:vncitizens_camera/src/core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  await initAppTranslation();
  await initAppRoute();
}
