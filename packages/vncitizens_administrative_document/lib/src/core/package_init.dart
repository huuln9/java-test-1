import 'package:vncitizens_administrative_document/src/core/route_init.dart';
import 'package:vncitizens_administrative_document/src/core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  await initAppTranslation();
  await initAppRoute();
}
